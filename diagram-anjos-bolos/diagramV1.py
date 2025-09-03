from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, InternetGateway, ALB, RouteTable
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.storage import S3
from diagrams.onprem.client import User
from diagrams.onprem.network import Internet

with Diagram("Arquitetura AWS - VPC", show=True, direction="LR"):

    usuario = User("Usuário")
    internet = Internet("Internet")

    with Cluster("VPC 10.25.0.0/26"):
        igw = InternetGateway("Internet Gateway")
        router = RouteTable("Router")
        alb_public = ALB("Public Load Balancer (ALB)")
        alb_private = ALB("Private Load Balancer (ALB)")

        usuario >> internet >> igw >> router >> alb_public

        with Cluster("Zona de Disponibilidade 1A"):
            with Cluster("Public Subnet\n10.25.0.0/28 = 11 Hosts"):
                front1 = EC2("Front-end")

            with Cluster("Private Subnet\n10.25.0.16/28 = 11 Hosts"):
                back1 = EC2("Back-end")
                db1 = RDS("Banco de Dados")

        with Cluster("Zona de Disponibilidade 1B"):
            with Cluster("Public Subnet\n10.25.0.32/28 = 11 Hosts"):
                front2 = EC2("Front-end")

            with Cluster("Private Subnet\n10.25.0.48/28 = 11 Hosts"):
                back2 = EC2("Back-end")
                db2 = RDS("Banco de Dados")

        alb_public >> front1
        alb_public >> front2

        front1 >> alb_private
        front2 >> alb_private

        alb_private >> back1
        alb_private >> back2

        back1 >> db1
        back2 >> db2

        s3_1 = S3("S3")
        s3_2 = S3("S3")

        db1 >> s3_1
        db2 >> s3_2
