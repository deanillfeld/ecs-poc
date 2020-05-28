GIT_COMMIT = $(git rev-parse --short HEAD)

dockerLogin:
	aws ecr get-login-password | docker login --username AWS --password-stdin 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com

dockerBuild:
	docker build -t 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com/nginxdemo:$(GIT_COMMIT) app

dockerPush: dockerLogin
	docker push 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com/nginxdemo:$(GIT_COMMIT) app
