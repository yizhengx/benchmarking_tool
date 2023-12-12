from locust import HttpUser, task
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
        self.client.post("/user",  {"username":username, "password":password})