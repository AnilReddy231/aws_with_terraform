resource "random_string" "rootUserPassword" {
 length = 16
 special = true
 override_special = "_+=,{.!-#%?}@"
}

resource "random_string" "monitorUserPassword" {
 length = 16
 special = true
 override_special = "_+=,{@.!-#%?}"
}