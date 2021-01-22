Configuration files.

Usage:

```bash
git clone https://github.com/farhanmustar/dotfiles ~/dotfiles
rsync -a ~/dotfiles/ ~
rm -rf ~/dotfiles
```

This configuration require vim 8.0. Older ubuntu system need to update vim using third party source.
```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install vim
```

## Vim-Ale linter list

| Filetype | Linter                                                                 | Installation                            |
| -------- | ---------------------------------------------------------------------- | --------------------------------------- |
| vim      | [vimls](https://github.com/iamcco/vim-language-server)                 | npm install -g vim-language-server      |
| python   | [ale-python-linter](https://github.com/farhanmustar/ale-python-linter) | Plugin 'farhanmustar/ale-python-linter' |
