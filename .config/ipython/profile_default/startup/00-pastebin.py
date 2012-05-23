import netrc, urlparse
from xmlrpclib import ServerProxy

def get_authenticated_url(url):
    s = list(urlparse.urlsplit(url))
    auth = netrc.netrc().authenticators(s[1])
    if not auth:
        return url
    s[1] = '%s:%s@%s' % (auth[0], auth[2], s[1])
    return urlparse.urlunsplit(s)

def magic_pastebin(self, parameter_s = ''):
    """Upload code to the 'Lodge it' paste bin, returning the URL."""
    ih = self.history_manager.input_hist_raw[1:-1]
    oh = self.history_manager.output_hist
    code = ""
    for n, line in enumerate(ih):
        result = oh.get(n+1)
        code += ">>> %s\n" % line
        if result:
            code += "%s\n" % result
    pburl = get_authenticated_url('https://paste.scrapinghub.com/xmlrpc/')
    pbserver = ServerProxy(pburl)
    id = pbserver.pastes.newPaste("pycon", code)
    return "http://paste.scrapinghub.com/show/" + id

ip = get_ipython()
ip.define_magic('pb', magic_pastebin)
