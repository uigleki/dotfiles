{
  programs.aria2 = {
    enable = true;
    settings = {
      max-concurrent-downloads = 5;
      max-connection-per-server = 16;
      split = 64;
      continue = true;
      always-resume = false;
      connect-timeout = 10;
      timeout = 10;
      max-tries = 0;
      retry-wait = 10;
      max-file-not-found = 10;

      disk-cache = "64M";
      file-allocation = "none";
      save-session-interval = 10;
      auto-save-interval = 10;
      remote-time = true;
      min-split-size = "4M";
      piece-length = "1M";
      allow-piece-length-change = true;

      http-accept-gzip = true;
      reuse-uri = false;
      no-netrc = true;
      content-disposition-default-utf8 = true;

      bt-max-peers = 128;
      bt-request-peer-speed-limit = "10M";
      max-overall-upload-limit = "2M";
      seed-time = 0;
      bt-enable-lpd = true;
      bt-force-encryption = true;
      bt-remove-unselected-file = true;
      bt-detach-seed-only = true;
      bt-save-metadata = true;
      bt-load-saved-metadata = true;
      bt-prioritize-piece = "head=32M,tail=32M";
      dht-entry-point = "dht.transmissionbt.com:6881";
      dht-entry-point6 = "dht.transmissionbt.com:6881";
      listen-port = 51413;
      dht-listen-port = 51413;
      bt-tracker-connect-timeout = 10;
      bt-tracker-timeout = 10;

      user-agent = "Transmission/3.00";
      peer-agent = "Transmission/3.00";
      peer-id-prefix = "-TR3000-";
    };
  };
}
