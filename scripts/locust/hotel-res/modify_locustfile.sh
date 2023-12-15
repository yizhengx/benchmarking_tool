delay=$1
to_write="wait_time = constant_throughput(${delay})"
if [ "$delay" == "" ]
then
    to_write=""
fi

cat << EOF > locustfile.py
from locust import HttpUser, task, constant_throughput
import random

class HelloWorldUser(HttpUser):

    def generate_user_password(self):
        id_ = random.randint(0, 500)
        username = f"Cornell_{id_}"
        password = ""
        for i in range(0, 10, 1):
            password += str(id_)
        return username, password

    @task
    def user_login(self):
        username, password = self.generate_user_password()
        with self.client.rename_request("/user_login"):
            self.client.post(f"/user?username={username}&password={password}")
    
    ${to_write}
EOF