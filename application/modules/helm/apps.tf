resource "kubernetes_manifest" "app_of_apps" {
  depends_on = [helm_release.argocd]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-of-apps"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "git@github.com:iddchn/notely-kubernetes.git"
        targetRevision = "HEAD"
        path : "infra-apps"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

resource "kubernetes_manifest" "app-notely" {
  depends_on = [kubernetes_manifest.app_of_apps]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-notely"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "git@github.com:iddchn/notely-kubernetes.git"
        targetRevision = "HEAD"
        path : "notely/notely-chart"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "notely"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

