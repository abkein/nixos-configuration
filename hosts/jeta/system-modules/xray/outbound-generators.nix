{ lib, xray-creds, ... }: {
  mkYun_vless-reality-xhttp =
    postfix: address:
    let
      inherit (xray-creds) yun;
    in
    {
      tag = "yun-vless-reality-xhttp-${postfix}";
      sendThrough = "0.0.0.0";
      protocol = "vless";
      settings = {
        address = address;
        port = yun.port;
        id = yun.id;
        flow = "xtls-rprx-vision";
        encryption = yun.encryption;
        level = 0;
      };
      streamSettings = {
        network = "xhttp";
        security = "reality";
        realitySettings = {
          show = false;
          fingerprint = "firefox";
          serverName = "www.microsoft.com";
          password = yun.password;
          shortId = yun.shortId;
          mldsa65Verify = yun.mldsa65Verify;
          spiderX = "/fi-fi";
        };
        xhttpSettings = {
          path = "/api/v1/data";
          mode = "auto"; # "stream-one";
          extra = {
            xPaddingBytes = "100-1000";
          };
        };
      };
      # mux = {
      #   enabled = true;
      #   concurrency = 8;
      #   xudpConcurrency = 16;
      #   xudpProxyUDP443 = "allow";
      # };
    };
  mkRegnetVLESS3 =
    postfix: addrress:
    let
      inherit (xray-creds) regnet;
    in
    {
      tag = "regnet-vless-reality-${postfix}";
      sendThrough = "0.0.0.0";
      protocol = "vless";
      settings = {
        address = addrress;
        port = regnet.port;
        id = regnet.id;
        flow = "xtls-rprx-vision";
        encryption = "none";
        level = 0;
      };
      streamSettings = {
        network = "raw";
        security = "reality";
        sockopt = {
          dialerProxy = "fragment";
        };
        realitySettings = {
          show = false;
          fingerprint = "chrome";
          serverName = "iv.okcdn.ru";
          publicKey = regnet.publicKey;
          shortId = regnet.shortId;
        };
      };
    };
  ussr-list =
    let
      confs = builtins.fromJSON (builtins.readFile ../../shadow/xray.json);
      outbounds_raw = lib.flatten (map (conf: conf.outbounds) confs);
      filtered_raw = lib.filter (
        outbound: (outbound.tag != "block") && (outbound.tag != "direct") && (outbound.tag != "direct")
      ) outbounds_raw;
      fixed = map (
        outbound:
        let
          settings = builtins.elemAt outbound.settings.vnext 0;
          new-settings = (removeAttrs settings [ "users" ]) // (builtins.elemAt settings.users 0);
        in
        if ((builtins.length outbound.settings.vnext) > 1) then
          throw "Outbound ${outbound.tag} has more than 1 `vnext` objects: ${toString (builtins.length outbound.settings.vnext)}"
        else
          (outbound // { settings = new-settings; })
      ) filtered_raw;
      filtered = lib.filter (
        outbound:
        (outbound.tag != "us-proxy")
        && (outbound.tag != "tiktok-proxy")
        && (outbound.tag != "youtube-proxy")
        && (outbound.tag != "proxy-tcp-reality-bridge")
      ) fixed;
      renamed = lib.imap1 (i: outbound: outbound // { tag = "ussr-reality-${toString i}"; }) filtered;

      getFirstRename =
        tag: newtag:
        (builtins.elemAt (lib.filter (outbound: outbound.tag == tag) fixed) 0) // { tag = newtag; };
    in
    renamed
    ++ [
      (getFirstRename "proxy-tcp-reality-bridge" "ussr-bridge-reality")
      (getFirstRename "us-proxy" "ussr-reality-us")
      (getFirstRename "youtube-proxy" "ussr-reality-youtube")
    ];
}
