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