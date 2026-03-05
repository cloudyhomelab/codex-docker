variable "REGISTRY" { default = "docker.io" }
variable "NAMESPACE"  { default = "binarycodes" }
variable "IMAGE_NAME" { default = "codex-local" }
variable "CODEX_VERSION" { default = "0.110.0" }

group "default" {
  targets = ["all-java-versions"]
}

target "base-installer" {
  context = "."
  dockerfile = "Dockerfile"
  target = "base-installer"

  args = {
    CODEX_VERSION = CODEX_VERSION
  }

  labels = {
    "org.opencontainers.image.title" = "codex-local"
    "org.opencontainers.image.description" = "Docker container to run codex workloads"
    "net.cloudyhome.codex.version" = CODEX_VERSION
  }
}

target "all-java-versions" {
  inherits = ["base-installer"]
  target = "final"

  labels = {
    "org.opencontainers.image.version" = "jdk-${item.major}"
  }

  matrix = {
    item = [
      { major = "25", version = "25.0.2.fx-zulu", extra_tags = ["latest"] },
      { major = "21", version = "21.0.10.fx-zulu", extra_tags = ["lts"] },
      { major = "17", version = "17.0.18.fx-zulu", extra_tags = [] },
      { major = "11", version = "11.0.30.fx-zulu", extra_tags = [] },
      { major = "8",  version = "8.0.482.fx-zulu", extra_tags = [] },
    ]
  }

  name="jdk-${item.major}"

  args = {
    JAVA_VERSION = item.version
  }

  tags = concat(
    ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:jdk-${item.major}"],
    [for t in item.extra_tags : "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${t}"]
    )
}

target "multi-arch" {
  inherits = ["base-installer"]
  target = "final"

  labels = {
    "org.opencontainers.image.version" = "jdk-${item.major}"
  }

  matrix = {
    item = [
      { major = "25", version = "25.0.2.fx-zulu", extra_tags = ["latest"] },
      { major = "21", version = "21.0.10.fx-zulu", extra_tags = ["lts"] },
      { major = "17", version = "17.0.18.fx-zulu", extra_tags = [] },
      { major = "11", version = "11.0.30.fx-zulu", extra_tags = [] },
      { major = "8",  version = "8.0.482.fx-zulu", extra_tags = [] },
    ]
  }

  name="jdk-${item.major}"

  args = {
    JAVA_VERSION = item.version
  }

  tags = concat(
    ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:jdk-${item.major}"],
    [for t in item.extra_tags : "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${t}"]
    )

  platforms = ["linux/amd64", "linux/arm64"]
}
