# -*- coding: utf-8 -*-

import vim
from ncm2 import Ncm2Source, getLogger
# import re
# from os.path import expanduser, expandvars
import subprocess

logger = getLogger(__name__)


def log(msg):
    from datetime import datetime
    timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S,%f")
    with open('/tmp/ncm2-mercurial.log', 'a') as file_:
        file_.write('%s %s\n' % (timestamp, msg))


class Source(Ncm2Source):
    def __init__(self, nvim):
        super(Source, self).__init__(nvim)
        # self.executable_look = nvim.call('executable', 'look')

    def on_complete(self, ctx):

        query = ctx['base']
        command = ['hg', 'branches', '--template',
                   '{branch}\t{rev}:{node|short}\n']
        try:
            lines = subprocess.check_output(command, stderr=subprocess.PIPE)
        except subprocess.CalledProcessError:
            return

        lines = lines.decode('utf-8', errors='ignore').splitlines()
        lines = [line.split() for line in lines]
        # log('lines: %s' % lines)
        matches = [{'word': branch,
                    'abbr': branch,
                    'menu': revision,
                    'custom': query + branch, }
                   for branch, revision in lines]
        self.complete(ctx, ctx['startccol'], matches)


source = Source(vim)

on_complete = source.on_complete
