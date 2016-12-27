{% from "vim/map.jinja" import vim with context %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

{% for name, user in pillar.get('vim', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', "/home/%s" % name) %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

vimrc_local:
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

vimdir_{{ name }}:
  file.directory:
    - name: {{ home }}/.vim
    - user: {{ name }}
    - group: {{ name }}
    - recurse:
      - user
      - group
    - require:
      - file: vimrc_{{ name }}

{% endfor %}
