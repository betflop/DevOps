terraform {
  source = "../modules//folder/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name        = "testfolder"
}

