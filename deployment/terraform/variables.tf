variable "IMAGE_NAME" {
  type        = string
  default     = "app"
  description = "Docker image app name"
}

variable "REPO" {
  type        = string
  default     = "lek-x"
  description = "Docker repo"
}

variable "VERSION" {
  type        = number
  default     = 1
  description = "Docker image build version"
}

variable "JOB_ENV" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "POSTGRES_PORT" {
  type        = number
  default     = 5432
  description = "PostgreSQL port"
}

variable "POSTGRES_PASSWORD" {
  type        = string
  default     = "test"
  description = "PostgreSQL  db password"
}

variable "BOT_TOKEN" {
  type        = string
  default     = "test"
  description = "TG bot token"
}

variable "POSTGRES_DB" {
  type        = string
  default     = "test"
  description = "PostgreSQL  db name"
}
variable "POSTGRES_USER" {
  type        = string
  default     = "test"
  description = "PostgreSQL  db user"
}
