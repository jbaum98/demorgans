{ lib, stdenv, fetchurl, texlive }:
let
  ND = stdenv.mkDerivation rec {
    name = pname;

    pname = "nd3.sty";
    tlType = "run";

    src = fetchurl {
      url = https://www.logicmatters.net/resources/nd3.sty;
      sha256 = "1wdk89gzkkzk7gs2sga4i3rxq2p267bqfccxi89yknrgvsizjlc2";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/tex/latex
      cp ${src} $out/tex/latex/nd3.sty
    '';
  };

  tex = texlive.combine {
    inherit (texlive)
    scheme-basic xetex euenc latexmk dvisvgm
    collection-fontsrecommended
    xargs xkeyval
    ;

    ND = {
      pkgs = [ ND ];
    };
  };

in stdenv.mkDerivation {
  name = "dermorgans";

  src = lib.sourceFilesBySuffices ./. [ ".tex" ];

  nativeBuildInputs = [ tex ];

  buildPhase = ''
    latexmk --xelatex demorgans.tex
  '';

  installPhase = ''
    cp demorgans.pdf $out
  '';
}
