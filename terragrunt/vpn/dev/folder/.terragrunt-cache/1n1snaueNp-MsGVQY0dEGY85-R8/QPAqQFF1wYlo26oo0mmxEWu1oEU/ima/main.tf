resource "yandex_iam_service_account" "yiam_test1" {
  name      = "yiam-test1"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "yiam_test2" {
  name      = "yiam-test2"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "yiam_test3" {
  name      = "yiam-test3"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "ydb-editor" {
  folder_id = var.folder_id
  role = "ydb.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.yiam_test1.id}",
    "serviceAccount:${yandex_iam_service_account.yiam_test2.id}",
    "serviceAccount:${yandex_iam_service_account.yiam_test3.id}"
  ]
}

