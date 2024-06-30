
resource "local_file" "pgsql" {
  content = templatefile(
    "${path.module}/templates/pgsql.tpl",
    {
      JOB_ENV           = var.JOB_ENV
      POSTGRES_PORT     = var.POSTGRES_PORT
      POSTGRES_USER     = var.POSTGRES_USER
      POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
      POSTGRES_DB       = var.POSTGRES_DB
    }
  )
  filename = "../../k8s/${var.JOB_ENV}/pgsql.yaml"
}

resource "local_file" "app" {
  content = templatefile(
    "${path.module}/templates/app.tpl",
    {
      IMAGE_NAME        = var.IMAGE_NAME
      VER               = var.VERSION
      REPO              = var.REPO
      JOB_ENV           = var.JOB_ENV
      POSTGRES_USER     = var.POSTGRES_USER
      POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
      POSTGRES_PORT     = var.POSTGRES_PORT
      POSTGRES_DB       = var.POSTGRES_DB
      BOT_TOKEN         = var.BOT_TOKEN
    }
  )
  filename = "../../k8s/${var.JOB_ENV}/app.yaml"
}
