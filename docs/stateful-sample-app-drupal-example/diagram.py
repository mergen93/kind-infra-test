from diagrams import Diagram, Edge, Cluster
from diagrams.k8s.compute import Deploy, Pod
from diagrams.k8s.network import Ing, SVC
from diagrams.k8s.storage import PV, PVC, SC
from diagrams.k8s.podconfig import Secret
from diagrams.onprem.network import Nginx

graph_attr={
    "fontsize":"40"
}
node_attr = {
"fontsize": "18",
}
edge_attr = {
"fontsize": "18",
}

with Diagram("Stateful Drupal8 Sample App Using Persistent Volumes", filename="diagram", show=False,graph_attr=graph_attr,node_attr=node_attr):

    nginx_ingress_ctrl = Nginx("controller")

    db_svc = SVC("db")
    drupal_svc = SVC("drupal")

    db_deploy = Deploy("db")

    db_pod = Pod("db")

    drupal_ingress = Ing("drupal")
    db_pv = PV("db-RWO")
    db_pvc = PVC("db-RWO")

    with Cluster("Frontend Drupal Pods"):
        d_pods = [
            Pod("drupal")]
        db_secret = Secret('db') >> d_pods
        drupal_deploy = Deploy("drupal")

    with Cluster("Frontend Drupal Http Data"):
        drupal_pv = PV("drupal-RWM")
        drupal_pvc = PVC("drupal-RWM")

    with Cluster("Backend"):
      d_pods >> Edge(label="db-traffic",fontsize="18") >> db_svc >> db_deploy >> db_pod >> db_pvc >> db_pv

    nginx_ingress_ctrl - drupal_ingress >> Edge(label="web-traffic",fontsize="18") >> drupal_svc >> drupal_deploy
    drupal_deploy >> d_pods >> drupal_pvc >> drupal_pv
