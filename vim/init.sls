{% from "vim/map.jinja" import vim with context %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

{% for name, user in pillar.get('vim', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', "/home/%s" % name) %}

neobundle_{{ name }}:
  git.latest:
    - name: https://github.com/Shougo/neobundle.vim.git
    - target: {{ home }}/.vim/bundle/neobundle.vim

vimrc_{{ name }}:
  file.managed:
    - name: {{ home }}/.vimrc
    - source: salt://vim/vimrc
    - template: jinja
    - context: {{ user | json() }}
    - defaults:
        bundles: []
        background: dark
        colorscheme: default
        mapleader: ","
        tabwidth: 2
    - mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - require:
      - pkg: vim
      - git: neobundle

vimplugins_{{ name }}_dir:
  file.directory:
    - name: {{ home }}/.vim/plugin
    - mode: 755
    - user: {{ name }}
    - group: {{ name }}

{% for plugin in user.get('plugins', []) %}

vimplugins_{{ name }}_{{ plugin }}:
  file.managed:
    - name: {{ home }}/.vim/plugin/{{ plugin }}.vim
    - source: salt://{{ name }}/vim/{{ plugin }}
    - mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - require:
      - pkg: vim
      - vimplugins_{{ name }}_dir

{% endfor %}

vimdir_{{ name }}:
  file.directory:
    - name: {{ home }}/.vim
    - user: {{ name }}
    - group: {{ name }}
    - recurse:
      - user
      - group
    - require:
      - file: vimrc_local

{% endfor %}
