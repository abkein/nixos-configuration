pkgs:
let
  inherit (pkgs) lib;
  inherit (lib) makeOverridable;

  buildZoteroXpiAddon = makeOverridable (
    {
      stdenv ? pkgs.stdenv,
      pname,
      version,
      addonId,
      src,
      meta,
      ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit src meta;

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/zotero/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    }
  );
  fetchGitHubReleaseFile =
    {
      owner,
      repo,
      tag,
      file,
      hash,
    }:
    pkgs.fetchurl {
      inherit hash;
      url = "https://github.com/${owner}/${repo}/releases/download/${tag}/${file}";
    };
in
{
  format-metadata = buildZoteroXpiAddon rec {
    pname = "zotero-format-metadata";
    version = "3.1.0";
    addonId = "zotero-format-metadata@northword.cn";

    src = fetchGitHubReleaseFile {
      owner = "northword";
      repo = pname;
      tag = "v${version}";
      file = "linter-for-zotero.xpi";
      hash = "sha256-o/Afn9u4gTK4T9VFJVk9uRhpdCWUSK+r7eCZgsF2vG0=";
    };

    meta = with lib; {
      homepage = "https://github.com/northword/zotero-format-metadata";
      license = licenses.agpl3Only;
      platforms = platforms.all;

      # Does stdenv support these?
      # description = "Python wrapper for the arXiv API";
      # changelog = "https://github.com/lukasschwab/arxiv.py/releases/tag/${src.tag}";
    };
  };

  pdf-translate = buildZoteroXpiAddon rec {
    pname = "zotero-pdf-translate";
    version = "2.4.4";
    addonId = "zoteropdftranslate@euclpts.com";

    src = fetchGitHubReleaseFile {
      owner = "windingwind";
      repo = pname;
      tag = "v${version}";
      file = "translate-for-zotero.xpi";
      hash = "sha256-Pw6oK2G5pc/sk4tGO5Uom7nCt9C0NoCynqq9Jb9qLEM=";
    };

    meta = with lib; {
      homepage = "https://github.com/windingwind/zotero-pdf-translate";
      license = licenses.agpl3Plus;
      platforms = platforms.all;
    };
  };

  reference = buildZoteroXpiAddon rec {
    pname = "zotero-reference";
    version = "1.7.2";
    addonId = "zoteroreference@polygon.org";

    src = fetchGitHubReleaseFile {
      owner = "MuiseDestiny";
      repo = pname;
      tag = version;
      file = "zotero-reference.xpi";
      hash = "sha256-ebZ4lkEFhziFXfLBzMgwQ0lZn8hMxGvzQjIkH4y8GEA=";
    };

    meta = with lib; {
      homepage = "https://github.com/MuiseDestiny/zotero-reference";
      license = licenses.agpl3Plus;
      platforms = platforms.all;
    };
  };

  metadata-hunter = buildZoteroXpiAddon rec {
    pname = "zotero-metadata-hunter";
    version = "0.3.1";
    addonId = "metadatahunter@federicotorrielli.github.io";

    src = fetchGitHubReleaseFile {
      owner = "federicotorrielli";
      repo = pname;
      tag = "v${version}";
      file = "metadatahunter@federicotorrielli.github.io-${version}.xpi";
      hash = "sha256-f2cWQg7Tyk4bpEhr+cWiNHS/hsvd+kk1PoUC6MWfgok=";
    };

    meta = with lib; {
      homepage = "https://github.com/federicotorrielli/zotero-metadata-hunter";
      # unclear license
      platforms = platforms.all;
    };
  };

  google-scholar-citation-count = buildZoteroXpiAddon rec {
    pname = "zotero-google-scholar-citation-count";
    version = "6.0.0";
    addonId = "justin@justinribeiro.com";

    src = fetchGitHubReleaseFile {
      owner = "justinribeiro";
      repo = pname;
      tag = "v${version}";
      file = "zotero-google-scholar-citation-count-${version}.xpi";
      hash = "sha256-GEXlDlS+PcbJnbjgKLZHgdVGO0Dq6fLTd7C5LgnfCkY=";
    };

    meta = with lib; {
      homepage = "https://github.com/justinribeiro/zotero-google-scholar-citation-count";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };

  mcp = buildZoteroXpiAddon rec {
    pname = "zotero-mcp";
    version = "1.4.7";
    addonId = "zotero-mcp-plugin@autoagent.my";

    src = fetchGitHubReleaseFile {
      owner = "cookjohn";
      repo = pname;
      tag = "v${version}";
      file = "zotero-mcp-plugin-${version}.xpi";
      hash = "sha256-xJhYVFrulQMTfMxr3l3Zz9xz0Oekz3hqnBrFknY8EQ0=";
    };

    meta = with lib; {
      homepage = "https://github.com/cookjohn/zotero-mcp";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  mineru = buildZoteroXpiAddon rec {
    pname = "zotero-mineru";
    version = "0.1.57";
    addonId = "zotero-mineru@example.com";

    src = fetchGitHubReleaseFile {
      owner = "lisontowind";
      repo = pname;
      tag = "v${version}";
      file = "zotero-mineru.xpi";
      hash = "sha256-0lr6cr07241i9nYSCX8QM1kq/Wn2iZUOX4ShEyEmN9I=";
    };

    meta = with lib; {
      homepage = "https://github.com/lisontowind/zotero-mineru";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  scipdf = buildZoteroXpiAddon rec {
    pname = "zotero-scipdf";
    version = "8.0.4";
    addonId = "scipdf@ytshen.com";

    src = fetchGitHubReleaseFile {
      owner = "syt2";
      repo = pname;
      tag = "V${version}";
      file = "sci-pdf.xpi";
      hash = "sha256-LWZHzH8mMKeJt+nExKgZIqva9sR45454KwOwxT6YPlY=";
    };

    meta = with lib; {
      homepage = "https://github.com/syt2/zotero-scipdf";
      license = licenses.agpl3Plus;
      platforms = platforms.all;
    };
  };

  notero = buildZoteroXpiAddon rec {
    pname = "notero";
    version = "1.2.3";
    addonId = "notero@vanoni.dev";

    src = fetchGitHubReleaseFile {
      owner = "dvanoni";
      repo = pname;
      tag = "v${version}";
      file = "notero-${version}.xpi";
      hash = "sha256-To2b8fl4pyiQj39rKmIgtR4IQDw/p0IKcS+smet2NVU=";
    };

    meta = with lib; {
      homepage = "https://github.com/dvanoni/notero";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  cita = buildZoteroXpiAddon rec {
    pname = "zotero-cita";
    version = "1.0.0-beta.19";
    addonId = "zotero-wikicite@wikidata.org";

    src = fetchGitHubReleaseFile {
      owner = "zotero-cita";
      repo = pname;
      tag = "v${version}";
      file = "zotero-cita.xpi";
      hash = "sha256-6LOfvvFPqPMhSy8HmjrCYEuEZboCkK6VSCwSJpFxsf8=";
    };

    meta = with lib; {
      homepage = "https://github.com/zotero-cita/zotero-cita";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
    };
  };

  zotseek = buildZoteroXpiAddon rec {
    pname = "ZotSeek";
    version = "1.14.0";
    addonId = "zotseek@zotero.org";

    src = fetchGitHubReleaseFile {
      owner = "introfini";
      repo = pname;
      tag = "v${version}";
      file = "zotseek-${version}.xpi";
      hash = "sha256-LnJPSPV1wDpTab0b+16SpM0UjQOwqzrGn4GlRz+jEpQ=";
    };

    meta = with lib; {
      homepage = "https://github.com/introfini/ZotSeek";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  zotxt = buildZoteroXpiAddon rec {
    pname = "zotxt";
    version = "9.0.0";
    addonId = "zotxt@e6h.org";

    src = fetchGitHubReleaseFile {
      owner = "egh";
      repo = pname;
      tag = "v${version}";
      file = "zotxt-${version}.xpi";
      hash = "sha256-/75pRXFDyVxc/0X4UbjeiljUtPIM4pkI0dhTgNZseCk=";
    };

    meta = with lib; {
      homepage = "https://github.com/egh/zotxt";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
    };
  };

  markdb-connect = buildZoteroXpiAddon rec {
    pname = "zotero-markdb-connect";
    version = "0.2.1";
    addonId = "daeda@mit.edu";

    src = fetchGitHubReleaseFile {
      owner = "daeh";
      repo = pname;
      tag = "v${version}";
      file = "markdb-connect.xpi";
      hash = "sha256-m1OCaohWrCt0hFrX2nXRQ+xE0SI1G9wvE5v4g2zvP0k=";
    };

    meta = with lib; {
      homepage = "https://github.com/daeh/zotero-markdb-connect";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  pubpeer = buildZoteroXpiAddon rec {
    pname = "pubpeer_zotero_plugin";
    version = "1.0.8";
    addonId = "zotero-pubpeer@pubpeer.com";

    src = fetchGitHubReleaseFile {
      owner = "PubPeerFoundation";
      repo = pname;
      tag = "v${version}";
      file = "zotero-pubpeer-${version}.xpi";
      hash = "sha256-R8BfdtHg1hFNI423uBEBlj4jkQpWkv75qQcMLNDKMsc=";
    };

    meta = with lib; {
      homepage = "https://github.com/PubPeerFoundation/pubpeer_zotero_plugin";
      # unclear license
      platforms = platforms.all;
    };
  };

  addons = buildZoteroXpiAddon rec {
    pname = "zotero-addons";
    version = "9.0.2";
    addonId = "zoteroAddons@ytshen.com";

    src = fetchGitHubReleaseFile {
      owner = "syt2";
      repo = pname;
      tag = "V${version}";
      file = "zotero-addons.xpi";
      hash = "sha256-uVXs7H8pL30WpHMUVdsq43MzsTDcA8WzazQlYh+R65w=";
    };

    meta = with lib; {
      homepage = "https://github.com/syt2/zotero-addons";
      license = licenses.agpl3Plus;
      platforms = platforms.all;
    };
  };

  arxiv-workflow = buildZoteroXpiAddon rec {
    pname = "zotero-arxiv-workflow";
    version = "0.3.7";
    addonId = "arxiv@allanchain.github.com";

    src = fetchGitHubReleaseFile {
      owner = "AllanChain";
      repo = pname;
      tag = "v${version}";
      file = "zotero-arxiv-workflow.xpi";
      hash = "sha256-56GJQreorgLm5QHozsXYfuxHgqevqHFUf0qLs6Ddzos=";
    };

    meta = with lib; {
      homepage = "https://github.com/AllanChain/zotero-arxiv-workflow";
      license = licenses.agpl3Plus;
      platforms = platforms.all;
    };
  };

  chartero = buildZoteroXpiAddon rec {
    pname = "Chartero";
    version = "2.11.0";
    addonId = "chartero@volatile.static";

    src = fetchGitHubReleaseFile {
      owner = "volatile-static";
      repo = pname;
      tag = "v${version}";
      file = "chartero.xpi";
      hash = "sha256-ToU4VUaAL2WFcXmcidhEPpSYIegyGlA69QPcuGMlQ2g=";
    };

    meta = with lib; {
      homepage = "https://github.com/volatile-static/Chartero";
      # package.json says AGPL-2.0-or-later, while LICENSE is Apache-2.0.
      platforms = platforms.all;
    };
  };

  zutilo = buildZoteroXpiAddon rec {
    pname = "Zutilo";
    version = "4.2.1";
    addonId = "zutilo@www.wesailatdawn.com";

    src = fetchGitHubReleaseFile {
      owner = "wshanks";
      repo = pname;
      tag = "v${version}";
      file = "zutilo.xpi";
      hash = "sha256-i/sKIdw87V1rh6jfkjyE+XgL3JQjS4NCmXPay17yCho=";
    };

    meta = with lib; {
      homepage = "https://github.com/wshanks/Zutilo";
      license = licenses.agpl3Only;
      platforms = platforms.all;
    };
  };

  inspire = buildZoteroXpiAddon rec {
    pname = "zotero-inspire";
    version = "3.0.2";
    addonId = "zoteroinspire@itp.ac.cn";

    src = fetchGitHubReleaseFile {
      owner = "fkguo";
      repo = pname;
      tag = "v${version}";
      file = "zotero-inspire.xpi";
      hash = "sha256-ITrrZrDIri1qEfyNhobwmOW207bloFipKsrWFzqA8UU=";
    };

    meta = with lib; {
      homepage = "https://github.com/fkguo/zotero-inspire";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };

  short-doi = buildZoteroXpiAddon rec {
    pname = "zotero-shortdoi";
    version = "1.6.0"; # "1.5.0";
    addonId = "zoteroshortdoi@wiernik.org";

    # src = fetchGitHubReleaseFile {
    #   owner = "bwiernik";
    #   repo = pname;
    #   tag = "v${version}";
    #   file = "zotero-doi-manager-${version}.xpi";
    #   hash = "sha256-dEruz3MDkyp3Gbcn37Z8/oJpsK9IqtS+sE7LWXeuwxY=";
    # };

    # Temporarily? fetch from fork, b/c upstream does not support Zotero 8, 9 yet
    src = fetchGitHubReleaseFile {
      owner = "JuliusBairaktaris";
      repo = pname;
      tag = "v${version}";
      file = "zotero-doi-manager-${version}.xpi";
      hash = "sha256-pSqEbRsoAYT2M7/mAwV0CUs9bSwMxE2tmKNxEdoJ3qA=";
    };

    meta = with lib; {
      homepage = "https://github.com/bwiernik/zotero-shortdoi";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };

  pmcid-fetcher = buildZoteroXpiAddon rec {
    pname = "zotero-pmcid-fetcher";
    version = "1.0.2";
    addonId = "zotero-pmcid-fetcher@iris-advies.com";

    src = fetchGitHubReleaseFile {
      owner = "retorquere";
      repo = pname;
      tag = "v${version}";
      file = "zotero-pmcid-fetcher-${version}.xpi";
      hash = "sha256-X8v2/NV6+IctVhyYcqNDR6Yj2RE7nl8ERYazUIlls78=";
    };

    meta = with lib; {
      homepage = "https://github.com/retorquere/zotero-pmcid-fetcher";
      # unclear license
      platforms = platforms.all;
    };
  };

  better-bibtex = buildZoteroXpiAddon rec {
    pname = "zotero-better-bibtex";
    version = "9.0.23";
    addonId = "better-bibtex@iris-advies.com";

    src = fetchGitHubReleaseFile {
      owner = "retorquere";
      repo = pname;
      tag = "v${version}";
      file = "zotero-better-bibtex-${version}.xpi";
      hash = "sha256-CX6gwKn/1kyJQpWtN1LcBqmz8HuIBqhK7fnW/PQ1cXw=";
    };

    meta = with lib; {
      homepage = "https://github.com/retorquere/zotero-better-bibtex";
      license = [ licenses.mit ];
      platforms = platforms.all;
    };
  };

  # Unlikely to work
  # cita = buildZoteroXpiAddon rec {
  #   pname = "zotero-cita";
  #   version = "0.5.5";
  #   addonId = "zotero-wikicite@wikidata.org";

  #   src = fetchGitHubReleaseFile {
  #     owner = "diegodlh";
  #     repo = pname;
  #     tag = "v${version}";
  #     file = "zotero-cita-v${version}.xpi";
  #     hash = "sha256-8L7wUABOMXoQ+irGZtcgpZu8cXHYLFR7UgCGKRmlJmQ=";
  #   };

  #   meta = with lib; {
  #     homepage = "https://github.com/diegodlh/zotero-cita";
  #     license = [ licenses.gpl3 ];
  #     platforms = platforms.all;
  #   };
  # };

  open-pdf = buildZoteroXpiAddon rec {
    pname = "zotero-open-pdf";
    version = "1.0.12";
    addonId = "zotero-open-pdf@iris-advies.com";

    src = fetchGitHubReleaseFile {
      owner = "retorquere";
      repo = pname;
      tag = "v${version}";
      file = "zotero-open-pdf-${version}.xpi";
      hash = "sha256-sqjFViYbMXxwoJOqAi0vA7Ewuf4z1XjtT3a8aP9qu38=";
    };

    meta = with lib; {
      homepage = "https://github.com/retorquere/zotero-open-pdf";
      # license unclear
      platforms = platforms.all;
    };
  };

  attachment-scanner = buildZoteroXpiAddon rec {
    pname = "zotero-attachment-scanner";
    version = "0.4.1";
    addonId = "attachmentscanner@changlab.um.edu.mo";

    src = fetchGitHubReleaseFile {
      owner = "SciImage";
      repo = pname;
      tag = "v${version}";
      file = "attachmentscanner-${version}.xpi";
      hash = "sha256-N7Vl+I2tMumF0wtNJUkspQpiwvOBR/eK0W2Kpcb74CI=";
    };

    meta = with lib; {
      homepage = "https://github.com/SciImage/zotero-attachment-scanner";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  # Archived, only up to Zotero 5
  # zotero-auto-index = buildZoteroXpiAddon rec {
  #   pname = "zotero-auto-index";
  #   version = "5.0.9";
  #   addonId = "auto-index@iris-advies.com";

  #   url = "https://github.com/retorquere/zotero-auto-index/releases/download/v${version}/zotero-auto-index-${version}.xpi";
  #   hash = "sha256-VmOZn+6g0KLCxkLafc+5DaTP9/Fvx32a9LUBD6NQ8MI=";

  #   meta = with lib; {
  #     homepage = "https://github.com/retorquere/zotero-auto-index";
  #     # TODO license
  #     platforms = platforms.all;
  #   };
  # };

  zotero-ocr = buildZoteroXpiAddon rec {
    pname = "zotero-ocr";
    version = "0.9.5.1";
    addonId = "zotero-ocr@bib.uni-mannheim.de";

    src = fetchGitHubReleaseFile {
      owner = "UB-Mannheim";
      repo = pname;
      tag = "${version}";
      file = "zotero-ocr-${version}.xpi";
      hash = "sha256-8QCz5gy087tpFmV261fnb3ACsk/1JkjCpoJ9aLU1r44=";
    };

    meta = with lib; {
      homepage = "https://github.com/UB-Mannheim/zotero-ocr";
      license = licenses.agpl3Only;
      platforms = platforms.all;
    };
  };

  # Only up to Zotero 6
  # zotero-robustlinks = buildZoteroXpiAddon rec {
  #   pname = "zotero-robustlinks";
  #   version = "2.0.0-20220320145937";
  #   addonId = "zotero-robustlinks@mementoweb.org";

  #   url = "https://github.com/lanl/Zotero-Robust-Links-Extension/releases/download/v${version}/robustlinks.xpi";
  #   hash = "sha256-U4ZPhFP06YP8xXmx8p0lTUa0nDtZN3YyrCPxtgz7D0E=";

  #   meta = with lib; {
  #     homepage = "https://robustlinks.mementoweb.org/zotero/";
  #     # TODO license
  #     platforms = platforms.all;
  #   };
  # };

  # Discontinued
  # zotero-abstract-cleaner = buildZoteroXpiAddon rec {
  #   pname = "zotero-abstract-cleaner";
  #   version = "0.1.6";
  #   addonId = "ZoteroAbstractCleaner@carter-tod.com";

  #   url = "https://github.com/dcartertod/zotero-plugins/releases/download/${version}/ZoteroAbstractCleaner.xpi";
  #   hash = "sha256-6ankwlieLLHiUPwhXptWwyomUaKCwEbVebTOWSbrLWs=";

  #   meta = with lib; {
  #     homepage = "https://github.com/dcartertod/zotero-plugins/tree/main/ZoteroAbstractCleaner";
  #     license = licenses.asl20;
  #     platforms = platforms.all;
  #   };
  # };

  # Discontinued, up to Zotero 7
  # zotero-preview = buildZoteroXpiAddon rec {
  #   pname = "zotero-preview";
  #   version = "0.7.0";
  #   addonId = "zoteropreview@carter-tod.com";

  #   url = "https://github.com/dcartertod/zotero-plugins/releases/download/${version}/ZoteroPreview7.xpi";
  #   hash = "sha256-tLZIFNhhkMa0tO7HRJIiuEQnpLrNwLD1e96Wl/qXv4g=";

  #   meta = with lib; {
  #     homepage = "https://github.com/dcartertod/zotero-plugins/tree/main/ZoteroPreview";
  #     license = licenses.asl20;
  #     platforms = platforms.all;
  #   };
  # };

  zotmoov = buildZoteroXpiAddon rec {
    pname = "zotmoov";
    version = "1.2.29";
    addonId = "zotmoov@wileyy.com";

    src = fetchGitHubReleaseFile {
      owner = "wileyyugioh";
      repo = pname;
      tag = "${version}";
      file = "zotmoov-${version}-fx.xpi";
      hash = "sha256-DDjziK93E6F4nxEXxLVA/bVj0OsS0fnuUd0nZR1yFl0=";
    };

    meta = with lib; {
      homepage = "https://github.com/wileyyugioh/zotmoov";
      license = [ licenses.gpl3 ];
      platforms = platforms.all;
    };
  };

  delitemwithatt = buildZoteroXpiAddon rec {
    pname = "delitemwithatt";
    version = "0.4.5";
    addonId = "delitemwithatt@redleaf.me";

    src = fetchGitHubReleaseFile {
      owner = "redleafnew";
      repo = pname;
      tag = "v${version}";
      file = "del-item-with-attachment.xpi";
      hash = "sha256-XCbwegs8jZ0h/KNaKnbF8D6Jj1iRLNbqasHKxVlZtnY=";
    };

    meta = with lib; {
      homepage = "https://github.com/redleafnew/delitemwithatt";
      license = [ licenses.agpl3Only ];
      platforms = platforms.all;
    };
  };

  scite = buildZoteroXpiAddon rec {
    pname = "scite-zotero-plugin";
    version = "2.0.5";
    addonId = "scite-zotero-plugin@scite.ai";

    src = fetchGitHubReleaseFile {
      owner = "scitedotai";
      repo = pname;
      tag = "v${version}";
      file = "scite-zotero-plugin-${version}.xpi";
      hash = "sha256-Ws8vMjHMabMUOkY+OlvY/pPIEwh9hycg7GZQUn2YT7M=";
    };

    meta = with lib; {
      homepage = "https://github.com/scitedotai/scite-zotero-plugin";
      license = [ licenses.agpl3Only ];
      platforms = platforms.all;
    };
  };

  zotero-gpt = buildZoteroXpiAddon rec {
    pname = "zotero-gpt";
    version = "3.1.4";
    addonId = "zoterogpt@polygon.org";

    src = fetchGitHubReleaseFile {
      owner = "MuiseDestiny";
      repo = pname;
      tag = "${version}";
      file = "zotero-gpt.xpi";
      hash = "sha256-NPB3oJtp0+e5NVp+isXFLuE/GPqewkxdYFxn/wKnfl0=";
    };

    meta = with lib; {
      homepage = "https://github.com/MuiseDestiny/zotero-gpt";
      license = [ licenses.agpl3Only ];
      platforms = platforms.all;
    };
  };

  better-notes = buildZoteroXpiAddon rec {
    pname = "zotero-better-notes";
    version = "2.0.18";
    addonId = "Knowledge4Zotero@windingwind.com";

    src = fetchGitHubReleaseFile {
      owner = "windingwind";
      repo = pname;
      tag = "v${version}";
      file = "better-notes-for-zotero.xpi";
      hash = "sha256-452gSKxqRC7jvEtRL6mrePXVROfyXwQfKsht72MFC1s=";
    };

    meta = with lib; {
      homepage = "https://github.com/windingwind/zotero-better-notes";
      license = [ licenses.agpl3Only ];
      platforms = platforms.all;
    };
  };

  # Up to Zotero 7
  # ai-research-assistant = buildZoteroXpiAddon rec {
  #   pname = "ai-research-assistant";
  #   version = "0.7.5";
  #   addonId = "aria@apex974.com";

  #   src = fetchGitHubReleaseFile {
  #     owner = "lifan0127";
  #     repo = pname;
  #     tag = "v${version}";
  #     file = "aria.xpi";
  #     hash = "sha256-xqki7703PPYdHqUwDGyG3+nBfabYVfnGz10EJ2oeH7c=";
  #   };

  #   meta = with lib; {
  #     homepage = "https://github.com/lifan0127/ai-research-assistant";
  #     license = [ licenses.agpl3Only ];
  #     platforms = platforms.all;
  #   };
  # };
}
