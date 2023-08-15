resource "aws_lb" "nacos-cluster-nlb" {
  name               = "nacos-cluster-nlb"
  internal           = true
  load_balancer_type = "application"
  security_groups = [var.nacos_cluster_sg]
  subnets         = [var.private_subnet_1a, var.private_subnet_1b]
  enable_deletion_protection = true
}

resource "aws_lb_listener" "nacos-cluster-nlb-listener-443" {
  load_balancer_arn = aws_lb.nacos-cluster-nlb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn = var.nacos_cluster_acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nacos-cluster-tg.arn
  }
}

resource "aws_lb_listener" "nacos-cluster-nlb-listener-80" {
  load_balancer_arn = aws_lb.nacos-cluster-nlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nacos-cluster-tg.arn
  }
}

resource "aws_lb_target_group" "nacos-cluster-tg" {
  name        = "nacos-cluster-tg"
  port        = 8848
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    path = "/nacos/img/nacos.png"
  }
}

resource "aws_lb_target_group_attachment" "register-tg" {
  for_each = toset(var.nacos_cluster_instance_ip)

  target_group_arn = aws_lb_target_group.nacos-cluster-tg.arn
  target_id        = each.key
  port             = 8848
}