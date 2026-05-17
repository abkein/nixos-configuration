{
  config,
  lib,
  pkgs,
  ...
}:
# Copied from https://github.com/somasis/nixos/blob/665bf28a1a36246c57b50cc10eb7afce6fc70de2/users/somasis/desktop/study/citation.nix#L122
# Copied from https://github.com/crisbour/nix-hm-config/blob/7de8636c67c65b42e66ba244dbdfaf5ced991a14/home/features/productivity/zotero/default.nix#L19
# let
#   # TODO Add UoE proxy
#   # proxy = "";
# in
{
  programs.zotero = {
    enable = true;

    # package = pkgs.zotero;

    profiles.default = {
      name = "default";
      id = 0;
      isDefault = true;
      path = "d6c407me.default";

      extensions = with pkgs.zotero-addons; [
        format-metadata
        pubpeer
        addons
        zutilo
        short-doi
        better-bibtex
        attachment-scanner
        zotero-ocr
        scite
        better-notes
        metadata-hunter

        google-scholar-citation-count
        mcp
        mineru
        scipdf
        cita
        zotxt

        # zotmoov
        # inspire
        # open-pdf
        # markdb-connect
        # chartero
        # zotero-gpt
        # zotseek
        # pdf-translate
        # arxiv-workflow
      ];

      settings = {
        # Attachment settings
        "extensions.zotero.useDataDir" = true;
        "extensions.zotero.dataDir" = "${config.xdg.userDirs.documents}/Zotero";
        "extensions.zotero.saveRelativeAttachmentPath" = true;
      };

      # settings = {
      #   # See <https://www.zotero.org/support/preferences/hidden_preferences> also.
      #   "general.smoothScroll" = true;
      #   "intl.accept_languages" = "en-US, en";
      #   # "browser.theme.toolbar-theme" = 0;

      #   # Use the flake-provided versions of translators and styles.
      #   "extensions.zotero.automaticScraperUpdates" = false;

      #   # Use Appalachian State University's OpenURL resolver
      #   #"extensions.zotero.openURL.resolver" = "${proxy}?url=https://resolver.ebscohost.com/openurl?";
      #   "extensions.zotero.findPDFs.resolvers" = [
      #     {
      #       "name" = "Sci-Hub";
      #       "method" = "GET";
      #       "url" = "https://sci-hub.ru/{doi}";
      #       "mode" = "html";
      #       "selector" = "#pdf";
      #       "attribute" = "src";
      #       "automatic" = true;
      #     }
      #     {
      #       "name" = "Google Scholar";
      #       "method" = "GET";
      #       "url" = "{z:openURL}https://scholar.google.com/scholar?q=doi%3A{doi}";
      #       "mode" = "html";
      #       "selector" = ".gs_or_ggsm a:first-child";
      #       "attribute" = "href";
      #       "automatic" = true;
      #     }
      #   ];

      #   # Sort settings
      #   "extensions.zotero.sortAttachmentsChronologically" = true;
      #   "extensions.zotero.sortNotesChronologically" = true;

      #   # Item adding settings
      #   "extensions.zotero.automaticSnapshots" = true; # Take snapshots of webpages when items are made from them
      #   "extensions.zotero.translators.RIS.import.ignoreUnknown" = false; # Don't discard unknown RIS tags when importing
      #   "extensions.zotero.translators.attachSupplementary" = true; # "Translators should attempt to attach supplementary data when importing items"
      #   "extensions.zotero.translators.better-bibtex.platform" = "lin";
      #   "extensions.zotero.translators.better-bibtex.path.git" = "${config.programs.git.package}/bin/git";
      #   "extensions.zotero.translators.better-bibtex.fillKeyAfter" = 1;
      #   "extensions.zotero.translators.better-bibtex.citekeyFormat" =
      #     "auth.lower + shorttitle(3, 3) + year";
      #   "extensions.zotero.translators.better-bibtex.citekeyFormatEditing" =
      #     "auth.lower + shorttitle(3,3) + year";
      #   # "extensions.zotero.translators.better-bibtex.path.texstudio" = ;
      #   # extensions.zotero.translators.better-bibtex.autoPinMigrated = true

      #   # Citation settings
      #   "extensions.zotero.export.lastStyle" = "https://www.zotero.org/styles/ieee";
      #   "extensions.zotero.export.lastLocale" = "en-US";
      #   "extensions.zotero.export.quickCopy.locale" = "en-US";
      #   "extensions.zotero.export.quickCopy.setting" = "bibliography=https://www.zotero.org/styles/ieee";
      #   "extensions.zotero.export.citePaperJournalArticleURL" = true;
      #   "extensions.zotero.export.bibliographySettings" =
      #     ''{"mode":"bibliography","method":"copy-to-clipboard"}'';
      #   # extensions.zotero.export.translatorSettings = {"exportNotes":true,"exportFileData":true,"includeAnnotations":true}

      #   # misc
      #   "extensions.zotero.fileHandler.pdf" = "system";
      #   "extensions.zotero.fileHandler.snapshot" = "system";
      #   "extensions.zotero.cite.automaticJournalAbbreviations" = false;
      #   "extensions.zotero.httpServer.localAPI.enabled" = true;

      #   # Feed options
      #   # "extensions.zotero.feeds.defaultTTL" = 24 * 7; # Refresh feeds every week
      #   # "extensions.zotero.feeds.defaultCleanupReadAfter" = 60; # Clean up read feed items after 60 days
      #   # "extensions.zotero.feeds.defaultCleanupUnreadAfter" = 90; # Clean up unread feed items after 90 days

      #   # Attachment settings
      #   "extensions.zotero.useDataDir" = true;
      #   "extensions.zotero.dataDir" = "${config.xdg.userDirs.documents}/Zotero";
      #   "extensions.zotero.saveRelativeAttachmentPath" = true;
      #   # "extensions.zotero.baseAttachmentPath" = "${study}/doc";

      #   # Reading settings
      #   "extensions.zotero.tabs.title.reader" = "filename"; # Show filename in tab title

      #   # Sync settings
      #   "extensions.zotero.sync.autoSync" = false;
      #   "extensions.zotero.sync.reminder.setUp.enabled" = false;
      #   "extensions.zotero.sync.server.username" = "abkein";
      #   "extensions.zotero.sync.storage.enabled" = false;
      #   "extensions.zotero.sync.storage.groups.enabled" = false;
      #   # "extensions.zotero.attachmentRenameFormatString" = "{%c - }%t{100}{ (%y)}"; # Set the file name format used by Zotero's internal stuff

      #   "extensions.zotero.autoRenameFiles.fileTypes" = lib.concatStringsSep "," [
      #     "application/pdf"
      #     "application/epub+zip"
      #     "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      #     "application/vnd.oasis.opendocument.text"
      #   ];

      #   #"extensions.zotero.aria.enabled" = true;

      #   # Zotero OCR
      #   "extensions.zotero.zoteroocr.pdftoppmPath" = "${pkgs.poppler-utils}/bin/pdftoppm";
      #   "extensions.zotero.zoteroocr.ocrPath" = "${pkgs.tesseract}/bin/tesseract";
      #   # "extensions.zotero.zoteroocr.language" = "eng";

      #   "extensions.zotero.zoteroocr.outputPDF" = true; # Output options > "Save output as a PDF with text layer"
      #   "extensions.zotero.zoteroocr.overwritePDF" = false; # Output options > "Save output as a PDF with text layer" > "Overwrite the initial PDF with the output"

      #   "extensions.zotero.zoteroocr.outputHocr" = false; # Output options > "Save output as a HTML/hocr file(s)"
      #   "extensions.zotero.zoteroocr.outputNote" = false; # Output options > "Save output as a note"
      #   "extensions.zotero.zoteroocr.outputPNG" = false; # Output options > "Save the intermediate PNGs as well in the folder"

      #   "ui.use_activity_cursor" = true;

      #   # Recursive view of articles in the hierarchy
      #   # "extensions.zotero.recursiveCollections" = true;

      #   # Enable Zotero API
      #   # TODO: Find how to enable Zotero API to work with Joplin ZoteroLink

      #   # LibreOffice extension settings
      #   # TODO Setup LibreOffice perhaps like `somasis` or keep with Joplin BibTex manual export
      #   # Alternative: explore Zotero Link plugin for Joplin
      #   "extensions.zotero.integration.useClassicAddCitationDialog" = true;
      #   "extensions.zoteroOpenOfficeIntegration.installed" = true;
      #   "extensions.zoteroOpenOfficeIntegration.skipInstallation" = true;
      # }

      # # TODO Other extensions settings to be enabled
      # # // {
      # #   # Add-ons > Citation settings
      # #   "extensions.zoteropreview.citationstyle" = style; # Zotero Citation Preview

      # #   # Add-ons > DOI Manager
      # #   "extensions.shortdoi.tag_invalid" = "#invalid_doi";
      # #   "extensions.shortdoi.tag_multiple" = "#multiple_doi";
      # #   "extensions.shortdoi.tag_nodoi" = "#no_doi";
      # # }

      # # Warning: Configuration options which will only become relevant with Zotero 7.
      # // {
      #   "extensions.zotero.reader.ebookFontFamily" = "serif";

      #   # "extensions.zotero.openReaderInNewWindow" = true;

      #   # ouch
      #   # "extensions.zotero.attachmentRenameTemplate" = ''
      #   #   {{ if {{ creators }} != "" }}{{ if {{ creators max="1" name-part-separator=", " }} == {{ creators max="1" name="family-given" }}, }}{{ creators max="2" name="family-given" join=", " suffix=" - " }}{{ else }}{{ if {{ creators max="1" }} != {{ creators max="2" }} }}{{ creators max="1" name="family-given" name-part-separator=", " join=", " suffix=" et al. - " }}{{ else }}{{ creators max="2" name="family-given" name-part-separator=", " join=", " suffix=" - " }}{{ endif }}{{ endif }}{{ else }}{{ creators max="1" name="family-given" name-part-separator=", " }}{{ endif }}{{ if shortTitle != "" }}{{ shortTitle }}{{ else }}{{ if {{ title truncate="80" }} == {{ title }} }}{{ title }}{{ else }}{{ title truncate="80" suffix="..." }}{{ endif }}{{ endif }}{{ if itemType == "book" }} ({{ year }}{{ publisher truncate="80" prefix=", " }}){{ elseif itemType == "bookSection" }} ({{ year }}{{ bookTitle prefix=", " truncate="80" }}){{ elseif itemType == "blogpost" }} ({{ if year != "" }}{{ year }}{{ blogTitle prefix=", " }}{{ else }}{{ blogTitle }}{{ endif }}){{ elseif itemType == "webpage" }} ({{ year }}{{ websiteTitle prefix=", " }}){{ elseif itemType == "newspaperArticle" }} ({{ year }}{{ publicationTitle truncate="80" prefix=", " }}{{ section truncate="80" prefix=", " }}){{ elseif itemType == "presentation" }} ({{ year }}{{ meetingName truncate="80" prefix=", " }}){{ elseif publicationTitle != "" }} ({{ year }}{{ publicationTitle truncate="80" prefix=", " }}{{ if volume != year }}{{ volume prefix=" "  }}{{ endif }}{{ issue prefix=", no. " }}){{ elseif year != "" }} ({{ year }}){{ endif }}
      #   # '';
      #   "extensions.zotero.autoRenameFiles.linked" = true;

      #   # <https://github.com/wileyyugioh/zotmoov>
      #   # "extensions.zotmoov.dst_dir" = "${study}/doc";
      #   # "extensions.zotmoov.allowed_fileext" = [ "pdf" "epub" "docx" "odt" ];
      #   # "extensions.zotmoov.delete_files" = true;

      #   # Enable userChrome
      #   # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      # };

      # userChrome = ''
      # * {
      #     /* Disable animations */
      #     transition: none !important;
      #     transition-duration: 0 !important;

      #     /* Square everything */
      #     border-radius: 0 !important;

      #     /* No shadows */
      #     box-shadow: none !important;
      # }

      # :root {
      #     --tab-min-height: 44px;
      # }

      # :root:not([legacytoolbar="true"]) {
      #     --tab-min-height: 36px;
      # }

      # /* Use Arc's style for toolbars */
      # #titlebar {
      #     background: ${config.theme.colors.background} !important; /* config.theme.colors.background */
      #     color: ${config.theme.colors.foreground} !important; /* config.theme.colors.foreground */
      # }
      # '';

    };
  };

  # TODO: Fill in engines to search with: https://github.com/somasis/nixos/blob/665bf28a1a36246c57b50cc10eb7afce6fc70de2/users/somasis/desktop/study/citation.nix#L379

}

#
# extensions.blocklist.pingCountVersion = -1
# extensions.databaseSchema = 37
# extensions.lastAppBuildId = 20260501234915
# extensions.lastAppVersion = 9.0.1.SOURCE.000000000
# extensions.lastPlatformVersion = 140.10.1
# extensions.pendingOperations = false
# extensions.signatureCheckpoint = 1
# extensions.systemAddonSet = {"schema":1,"addons":{}}
# extensions.ui.dictionary.hidden = true
# extensions.ui.extension.hidden = false
# extensions.ui.locale.hidden = true
# extensions.ui.plugin.hidden = false
# extensions.ui.sitepermission.hidden = true

# extensions.zotero.autoRenameFiles.done = false
# extensions.zotero.firstRun.skipFirefoxProfileAccessCheck = true
# extensions.zotero.firstRun2 = false
# extensions.zotero.firstRunGuidanceShown.readAloud = false
# extensions.zotero.ignoreLegacyDataDir.auto = true

# extensions.zotero.pane.persist = {"zotero-reader-sidebar-pane":{"collapsed":"true"},"zotero-layout-switcher":{"orient":"horizontal"},"zotero-items-splitter":{"orient":"horizontal"},"zotero-item-pane":{"width":"337","height":"205"},"zotero-context-splitter":{"state":"collapsed"},"zotero-context-splitter-stacked":{"state":"collapsed"}}
# extensions.zotero.panes.abstract.open = true
# extensions.zotero.panes.attachment-annotations.open = true
# extensions.zotero.panes.attachment-info.open = true
# extensions.zotero.panes.attachments.open = true
# extensions.zotero.panes.better-bibtex-iris-advies-com-betterbibtex-section-citationkey.open = true
# extensions.zotero.panes.info.open = true
# extensions.zotero.panes.libraries-collections.open = true
# extensions.zotero.panes.note-info.open = true
# extensions.zotero.panes.notes.open = true
# extensions.zotero.panes.preview.open = true
# extensions.zotero.panes.pubpeer-pubpeer-com-pubpeer-section-peer-comments.open = false
# extensions.zotero.panes.related.open = true
# extensions.zotero.panes.scite-zotero-plugin-scite-ai-scite-zotero-plugin-pane.open = true
# extensions.zotero.panes.scite-zotero-plugin\@scite\.ai-scite-zotero-plugin-pane.open = true
# extensions.zotero.panes.tags.open = true

# gecko.handlerService.defaultHandlersVersion = 1
# idle.lastDailyNotification = 1778837450
# intl.accept_languages = en-US, en
# media.gmp-gmpopenh264.abi = x86_64-gcc3
# media.gmp-gmpopenh264.hashValue = 94531e267314de661b2205c606283fb066d781e5c11027578f2a3c3aa353437c2289544074a28101b6b6f0179f0fe6bd890a0ae2bb6e1cf9053650472576366c
# media.gmp-gmpopenh264.lastDownload = 1740242173
# media.gmp-gmpopenh264.lastDownloadFailReason = [Exception... "File download failed"  nsresult: "0x193 (<unknown>)"  location: "JS frame :: resource://gre/modules/addons/ProductAddonChecker.sys.mjs :: downloadFile/</sr.onload :: line 439"  data: no]
# media.gmp-gmpopenh264.lastDownloadFailed = 1778837261
# media.gmp-gmpopenh264.lastInstallStart = 1778837261
# media.gmp-gmpopenh264.lastUpdate = 1740242173
# media.gmp-gmpopenh264.version = 1.8.1.2
# media.gmp.storage.version.observed = 1
# privacy.bounceTrackingProtection.hasMigratedUserActivationData = true
# privacy.purge_trackers.date_in_cookie_database = 0
# privacy.purge_trackers.last_purge = 1778837450581
# security.sandbox.content.tempDirSuffix = c38e0d7c-87c6-4252-9438-99658957c395
# storage.vacuum.last.content-prefs.sqlite = 1759103065
# storage.vacuum.last.index = 1
# storage.vacuum.last.places.sqlite = 1778276950
