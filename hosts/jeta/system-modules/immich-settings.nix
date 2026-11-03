{
  backup.database.enabled = false;
  ffmpeg = {
    ### Transcode policy
    transcode = "required";
    acceptedAudioCodecs = [ "opus" ];
    acceptedContainers = [ "webm" ];
    acceptedVideoCodecs = [ "av1" ];
    ### Encoding options
    targetVideoCodec = "av1";
    targetAudioCodec = "opus";
    targetResolution = "2160";
    # crf = 23;
    # preset = "veryslow";
    # maxBitrate = "0";
    threads = 4;
    tonemap = "hable";
    twoPass = false;
    ### Hardware Acceleration
    accel = "VAAPI";
    accelDecode = true;
    cqMode = "cqp";
    # preferredHwDevice = "auto";
    ### Realtime transcoding
    realtime.enabled = false;
  };
  image = {
    colorspace = "p3";
    extractEmbedded = false;
    fullsize.enabled = false;
    preview = {
      format = "webp";
      quality = 100;
      size = 1440;
      progressive = false;
    };
    thumbnail = {
      format = "webp";
      quality = 80;
      size = 250;
      progressive = false;
    };
  };
  integrityChecks = {
    checksumFiles.enabled = true;
    missingFiles.enabled = true;
    untrackedFiles.enabled = true;
  };
  job = {
    backgroundTask = {
      concurrency = 1;
    };
    editor = {
      concurrency = 2;
    };
    faceDetection = {
      concurrency = 1;
    };
    integrityCheck = {
      concurrency = 1;
    };
    library = {
      concurrency = 5;
    };
    metadataExtraction = {
      concurrency = 5;
    };
    migration = {
      concurrency = 5;
    };
    notifications = {
      concurrency = 5;
    };
    ocr = {
      concurrency = 1;
    };
    search = {
      concurrency = 5;
    };
    sidecar = {
      concurrency = 5;
    };
    smartSearch = {
      concurrency = 1;
    };
    thumbnailGeneration = {
      concurrency = 5;
    };
    videoConversion = {
      concurrency = 1;
    };
    workflow = {
      concurrency = 1;
    };
  };
  logging = {
    enabled = true;
    level = "log";
  };
  machineLearning = {
    enabled = true;
    urls = [ "http://localhost:3003" ];
    availabilityChecks = {
      enabled = true;
      interval = 30000;
      timeout = 2000;
    };
    clip = {
      enabled = true;
      modelName = "ViT-SO400M-16-SigLIP2-384__webli";
    };
    duplicateDetection.enabled = true;
    facialRecognition = {
      enabled = true;
      minFaces = 5;
      modelName = "antelopev2";
    };
    ocr = {
      enabled = true;
      modelName = "ESLAV__PP-OCRv5_mobile";
    };
  };
  map.enabled = true;
  metadata.faces.import = true;
  newVersionCheck.enabled = false;
  nightlyTasks = {
    databaseCleanup = true;
    syncQuotaUsage = true;
    clusterNewFaces = false;
    generateMemories = false;
    missingThumbnails = false;
    startTime = "00:00";
  };
  notifications.smtp.enabled = false;
  passwordLogin.enabled = true;
  reverseGeocoding.enabled = true;
  storageTemplate = {
    enabled = true;
    hashVerificationEnabled = true;
    template = "{{album}}/{{y}}/{{MM}}/{{dd}}/{{filename}}";
  };
  trash = {
    enabled = true;
    days = 30;
  };
  user.deleteDelay = 7;
}
