#!/usr/bin/env python

import json
import pathlib

class NodeBuilder:
    def __init__(self, count=4):
        self.data = {
            'resource': self.build_resources(count)
        }

        self.write()

    def build_resources(self, count):
        return {
            'coder_agent': self.build_coder_agents(count)
        }

    def build_coder_agents(self, count):
        data = dict()
        for i in range(count):
            data[f'node{i}'] = {
                'os': 'linux',
                'arch': 'amd64',
                'count': f'data.coder_parameter.node_count.value >= {i+1} ? data.coder_workspace.me.start_count : 0',
                'display_apps': {
                    'vscode': False,
                    'vscode_insiders': False,
                    'web_terminal': False,
                    'ssh_helper': False
                },
                'metadata': [
                    {
                        'key': 'cpu',
                        'display_name': 'CPU Usage',
                        'interval': 5,
                        'timeout': 5,
                        'script': 'coder stat cpu'
                    },
                    {
                        'key': 'memory',
                        'display_name': 'Memory Usage',
                        'interval': 5,
                        'timeout': 5,
                        'script': 'coder stat mem'
                    },
                    {
                        'key': 'disk',
                        'display_name': 'Home Usage',
                        'interval': 600, 
                        'timeout': 30,
                        'script': 'coder stat disk --path /home/user'
                    }
                 ]
            }
        return data

    def write(self):
        with open(pathlib.Path(__file__).parent / 'nodes.tf.json', 'w') as fp:
            json.dump(self.data, fp, indent=2, sort_keys=True)

if __name__ == '__main__':
    nb = NodeBuilder()
