ifdef CODEBUILD_BUILD_ARN
	GIT_COMMIT = $(shell echo $$CODEBUILD_RESOLVED_SOURCE_VERSION | head -c 7)
endif

dockerLogin:
	aws ecr get-login-password | docker login --username AWS --password-stdin 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com

dockerBuild:
	env
	docker build -t 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com/nginxdemo:$(GIT_COMMIT) app

dockerPush: dockerLogin
	docker push 722141136946.dkr.ecr.ap-southeast-2.amazonaws.com/nginxdemo:$(GIT_COMMIT)
