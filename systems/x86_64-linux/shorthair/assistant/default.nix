{  # look at https://github.com/mozilla/DeepSpeech
# stop building rocblas, use https://search.nixos.org/packages?channel=unstable&show=rocmPackages.rocblas&from=0&size=50&sort=relevance&type=packages&query=rocblas
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 1144;
  };
}
