{ fetchFromGitHub }:

[
  {
    name = "uniquify-files";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/uniquify-files-1.0.4.tar";
      sha256 = "sha256:047rcgi4ipqwhsm6w5sr5i0hkc3yv88ihiaybr70lwys51rmw1a9";
    };
  }
  {
    name = "wisi";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/wisi-4.3.2.tar";
      sha256 = "sha256:1rkjpnnj3fyafgi878ijjnjwnh3gd15qgjfp8gwlqicilgg8rqf8";
    };
  }

  {
    name = "gnat-compiler";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/gnat-compiler-1.0.3.tar";
      sha256 = "sha256:1qm57bph4fm6mb2b3ra4n3wnnk72p06mvc0wxdqn8dd6ff814izx";
    };
  }

  {
    name = "ada-mode";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/ada-mode-8.1.0.tar";
      sha256 = "sha256:1mi91xg5j8rxn53iw3faamb2di6rcm7wij0p5m181n6xihxpf4ni";
    };

    config = ''
        (add-to-list 'auto-mode-alist '("\\.ads\\'" . ada-mode))
        (add-to-list 'auto-mode-alist '("\\.adb\\'" . ada-mode))
      '';
  }
  {
    name = "devil";
    dir = fetchFromGitHub {
      owner = "susam";
      repo = "devil";
      rev = "0.6.0";
      hash = "sha256-Puwtz7gOYwUlgrIMg4/61Ly9ylPIWh08Ll+f4YzzKd8=";
    };

    config = ''
        (global-devil-mode)
      '';
  }
]
