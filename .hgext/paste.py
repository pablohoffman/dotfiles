#!/usr/bin/env python
'''Send diffs from Mercurial to various pastebin websites'''

import sys
import urllib2
from netrc import netrc
from base64 import urlsafe_b64encode
from mercurial import cmdutil, commands, help, util
from urllib import urlencode


def _paste_dpaste(content, syntax, title, user, keep, **kw):
    return ('http://dpaste.com/api/v1/', {
        'content': content, 
        'language': syntax or 'Diff',
        'title': title,
        'poster': user[:30],
        'hold': 'on' if keep else 'off',
        })

def _paste_dpaste_org(content, syntax, title, user, keep, **kw):
    return ('http://dpaste.org/', {
        'content': content,
        'lexer': syntax or 'diff',
        'title': title,
        'author': user[:30],
        'expire_options': '3110400000' if keep else '2592000',
        })

def _paste_pastebin_dixo_net(content, syntax, user, keep, **kw):
    return ('http://pastebin.dixo.net/', {
        'paste': 'Send',
        'code2': content,
        'format': syntax or 'diff',
        'poster': user,
        'expiry': 'f' if keep else 'm',
        })

def _paste_lodgeit(content, syntax, private, **kw):
    data = {'code': content, 'language': syntax or 'diff'}
    if private: data['private'] = 'on'
    return ('http://paste.pocoo.org/', data)

def _paste(handler, content, opts):
    default_url, data = handler(content, **opts)
    url = opts['url'] or default_url
    request = urllib2.Request(url, urlencode(data, doseq=1))
    _authorize_request(request, **opts)
    response = urllib2.urlopen(request)
    return response.geturl()

def _authorize_request(request, httpauth=None, usenetrc=None, **kwargs):
    """Sets basic authorization header using httpauth flag or netrc if enabled"""
    if httpauth:
        b64cred = urlsafe_b64encode(httpauth)
        request.add_header('Authorization', 'Basic %s' % b64cred)
    elif usenetrc:
        cred = netrc().authenticators(request.get_host())
        if cred:
            b64cred = urlsafe_b64encode('%s:%s' % (cred[0], cred[2]))
            request.add_header('Authorization', 'Basic %s' % b64cred)


def paste(ui, repo, *fnames, **opts):
    '''send diffs from Mercurial to various pastebin websites
    
    Send a diff of the specified files to a pastebin website to easily
    share with other people.  If no files are specified all files will
    be included.
    
    To paste a diff of all uncommitted changes in the working directory:
    
        hg paste
    
    To paste the changes that revision REV made:
    
        hg paste -r REV
    
    To paste the changes between revisions REV1 and REV2:
    
        hg paste -r REV1:REV2
    
    Several options can be used to specify more metadata about the paste:
    
        hg paste --user Steve --title 'Progress on feature X' --keep
    
    The pastebin website to use can be specified with --dest.  See
    'hg help pastebins' for more information.
    
    '''
    dest = opts.pop('dest')
    dry = opts.pop('dry_run')
    if not dest:
        dest = 'dpaste'

    handler = globals().get('_paste_' + dest.replace('.', '_'))
    if not handler:
        raise util.Abort('unknown pastebin (see "hg help pastebins")!')

    if not opts['user']:
        opts['user'] = ui.username().replace('<', '').replace('>', '')

    if opts['rev'] and opts['stdin']:
        raise util.Abort('--rev and --stdin options are mutually exclusive')

    if opts['stdin']:
        content = sys.stdin.read()
    else:
        ui.pushbuffer()
        if opts['rev']:
            rev = opts.pop('rev')
            revs = cmdutil.revrange(repo, rev)

            if len(revs) == 1:
                opts['change'] = revs[0]
            else:
                opts['rev'] = rev

            commands.diff(ui, repo, *fnames, **opts)
        else:
            commands.diff(ui, repo, *fnames, **opts)
        content = ui.popbuffer()

    if not content.strip():
        raise util.Abort('nothing to paste!')

    if ui.verbose:
        ui.status('Pasting:\n%s\n' % content)

    if not dry:
        url = _paste(handler, content, opts)
        ui.write('%s\n' % url)


cmdtable = {
    'paste': (paste, [
        ('r', 'rev',   [], 'paste a patch of the given revision(s)'),
        ('d', 'dest',  '', 'the pastebin site to use (defaults to dpaste)'),
        ('t', 'title', '', 'the title of the paste (optional)'),
        ('u', 'user',  '', 'the name of the paste\'s author (defaults to the '
                           'username configured for Mercurial)'),
        ('k', 'keep', False, 'specify that the pastebin should keep the paste '
                             'for as long as possible (optional)'),
        ('p', 'private', False, 'specify that the pastebin should mark a'
                             'paste as private if possible (optional)'),
        ('',  'dry-run', False, 'do not paste to the pastebin'),
        ('',  'url', '', 'perform request against this url'),
        ('',  'httpauth', '', 'http authorization (user:pass)'),
        ('',  'usenetrc', False, 'use ~/.netrc for http authorization'),
        ('',  'stdin', False, 'read content from standard input'),
        ('',  'syntax', '', 'choose syntax'),
    ] + commands.diffopts + commands.walkopts,
    'hg paste [OPTION] [-r REV] [FILE...]')
}

help.helptable += (
    (['pastebins', 'pastebins'], ('Pastebins supported by hg-paste'),
     (r'''
    Available pastebins:

    dpaste
        website: http://dpaste.com/
        supported metadata options: --title, --keep, --user --syntax

    dpaste.org
        website: http://dpaste.org/
        supported metadata options: --title, --keep, --user --syntax

    pastebin.dixo.net
        website: http://pastebin.dixo.net/
        supported metadata options: --keep, --user --syntax

    lodgeit
        website: http://paste.pocoo.org/
        supported metadata options: --syntax, --private
    ''')),
)
