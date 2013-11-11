class people::mono0x {
  include skype
  include chrome
  include firefox
  include dropbox
  include macvim_kaoriya

  include pow
  include postgresql

  package {
    [
      'tmux',
      'htop',
      'xz',
    ]:
  }

  package {
    'GoogleJapaneseInput':
      source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
  }

  package {
    'zsh':
      install_options => [
        '--disable-etcdir',
      ]
  }

  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::luser];
  }

  osx_chsh { $::luser:
    shell   => "${boxen::config::homebrewdir}/bin/zsh";
  }

  $home     = "/Users/${::luser}"
  $dotfiles = "${boxen::config::srcdir}/dotfiles"

  repository { $dotfiles:
    source  => "mono0x/dotfiles",
    require => File[$boxen::config::srcdir]
  }

  exec { "install dotfiles":
    cwd      => $dotfiles,
    command  => "${dotfiles}/build-env/common.sh",
    creates  => "${home}/.zshrc",
    require  => Repository[$dotfiles]
  }

  class { 'osx::global::key_repeat_rate':
    rate => 2
  }

  class { 'osx::global::key_repeat_delay':
    delay => 10
  }

  include osx::finder::unhide_library

}
