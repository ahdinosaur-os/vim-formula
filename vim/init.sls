{% from "vim/map.jinja" import vim with context %}
{% for name, user in pillar.get('vim', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', "/home/%s" % name) %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

neobundle:
  git.latest:
    - name: https://github.com/Shougo/neobundle.vim.git
    - target: {{ home }}/.vim/bundle/neobundle.vim

vimrc_local:
  file.managed:
    - name: {{ home }}/.vimrc
    - source: salt://vim/vimrc
    - template: jinja
    - context: {{ user }}
    - defaults:
      bundles: []
      background: dark
      colorscheme: default
      mapleader: ","
      tabwidth: 2
      vimrc: ""
    - mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - require:
      - pkg: vim
      - git: neobundle

vimdir_local:
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
