resource "aws_key_pair" "auth" {
    key_name = "${var.key_name}"
    public_key = "${var.public_key_path}"
}

resource "aws_instance" "instance" {
    ami = "${var.image_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    source_dest_check = false
    subnet_id = "${aws_subnet.public_subnet.id}"
    associate_public_ip_address = true

    tags = {
        BuiltWith = "terraform"
        Name = "Web Host"
    }

    vpc_security_group_ids = ["${aws_security_group.multitier_sg.id}"]

}





