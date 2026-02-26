provider "aws" {
  region = var.source_region
}

provider "aws" {
  alias  = "dr"
  region = var.destination_region
<<<<<<< HEAD
}
=======
}
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
