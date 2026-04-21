🐍 AWS ECS Fargate Snake Game 
Un'applicazione web containerizzata, distribuita in modo altamente scalabile su AWS. Il progetto utilizza un approccio Infrastructure as Code (IaC) con Terraform per gestire l'intero ciclo di vita delle risorse.


🏗️ L'Architettura 
Il sistema è progettato per essere Serverless, eliminando la necessità di gestire istanze EC2 dirette: 
	•	Cluster ECS & Fargate: I container girano su infrastruttura gestita da AWS, scalando in base alle necessità. 
	•	Application Load Balancer (ALB): Punto di ingresso unico che distribuisce il traffico ai Task ECS e monitora la loro salute (Health Checks). 
	•	Autoscaling: Implementata una policy di Target Tracking (soglia CPU 10%) per adattare dinamicamente il numero di container al traffico. 
	•	Networking: VPC strutturata con subnet pubbliche e private; i container sono protetti da un Security Group che accetta traffico solo dal bilanciatore. 

📦 Gestione Immagini (Docker & ECR) 
L'applicazione viene "impacchettata" localmente e resa disponibile al cloud tramite un registro privato: 
	1	Build: Creazione dell'immagine Docker con il codice sorgente.
	2	Push: Caricamento su Amazon ECR (Elastic Container Registry).

🛠️ Tecnologie Utilizzate 
	•	Terraform: Automazione dell'infrastruttura.
	•	Docker: Containerizzazione dell'app.
	•	AWS Services: ECS, ECR, ALB, IAM, VPC. 

🚀 Come Eseguire 
	1	Inizializza Terraform: terraform init
	2	Carica l'immagine: Seguire i "push commands" nella console AWS ECR.
	3	Distribuisci: terraform apply
	4	Gioca: Accedi tramite l'URL fornito dall'output alb_dns_name.

![Snake AWS Architecture](snake-container-aws/snake-aws.png)
