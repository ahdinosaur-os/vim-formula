{% from "vim/map.jinja" import vim with context %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

neobundle:
  git.latest:
    - name: https://github.com/Shougo/neobundle.vim.git
    - target: /etc/vim/bundle/neobundle.vim
  file.directory:
    - name: /etc/vim/bundle
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - mode
    - require:
      - git: neobundle

vimrc_local:
  file.managed:
    - name: /etc/vim/vimrc.local
    - source: salt://vim/vimrc.local
    - mode: 644
    - require:
      - pkg: vim
      - git: neobundle

vimrc_system:
  file.managed:
    - name: /etc/vim/vimrc.system
    - source:
      - salt://vim/vimrc.system
      - salt://vim/vimrc.default
    - mode: 644
    - require:
      - pkg: vim
      - file: vimrc_local

{% for userName, user in pillar.get('users', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set userHome = user.get('home', "/home/%s" % userName) -%}

{%- if 'prime_group' in user and 'userName' in user['prime_group'] %}
{%- set userGroup = user.prime_group.userName -%}
{%- else -%}
{%- set userGroup = userName -%}
{%- endif %}
{{userHome}}/.vimrc:
  file.managed:
    - source:
      - salt://vim/vimrc.{{userName}}
      - salt://vim/vimrc.default
    - user: {{userName}}
    - group: {{userGroup}}
    - mode: 644
    - require:
      - pkg: vim
      - file: vimrc_local
{% endfor %}