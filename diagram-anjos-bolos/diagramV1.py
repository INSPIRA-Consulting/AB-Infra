from diagrams import Diagram, Cluster
from diagrams.aws.network import InternetGateway, ALB, RouteTable
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
        
        # Public Load Balancer
        alb_public = ALB("Public Load Balancer (ALB)")
        
        # Front-end (Public Subnets)
        with Cluster("Public Subnets"):
            with Cluster("AZ 1A\n10.25.0.0/28 = 11 Hosts\nAccess Control List\nGrupos de Segurança"):
                front1 = EC2("Front-end 1A")
            with Cluster("AZ 1B\n10.25.0.32/28 = 11 Hosts\nAccess Control List\nGrupos de Segurança"):
                front2 = EC2("Front-end 1B")
        
        # Private Load Balancer
        alb_private = ALB("Private Load Balancer (ALB)")
        
        # Back-end (Private Subnets)
        with Cluster("Private Subnets"):
            with Cluster("AZ 1A\n10.25.0.16/28 = 11 Hosts\nAccess Control List\nGrupos de Segurança"):
                back1 = EC2("Back-end 1A")
                db1 = RDS("Database 1A")
            with Cluster("AZ 1B\n10.25.0.48/28 = 11 Hosts\nAccess Control List\nGrupos de Segurança"):
                back2 = EC2("Back-end 1B")
                db2 = RDS("Database 1B")

        # Conexões
        usuario >> internet >> igw >> router >> alb_public
        alb_public >> front1
        alb_public >> front2
        front1 >> alb_private
        front2 >> alb_private
        alb_private >> back1
        alb_private >> back2
        
        # Database replicado
        db1 - db2
        
        # Conexão back-end com Databases
        back1 >> db1
        back2 >> db2
        
    # Bucket S3 fora da VPC 
    s3 = S3("S3 Storage")
    db1 >> s3
    db2 >> s3
