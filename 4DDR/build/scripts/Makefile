
build:
	export CL_DIR=/home/yyonsel/bulk/aws-build/fletcher-aws/examples/tpch1/4DDR && source ${FLETCHER_AWS_DIR}/sourceme.sh && ./aws_build_dcp_from_cl.sh 
	
clean:
	@echo -n "Deleting build files. Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	rm -rf *.log last_log hd_visual *.str .cache .Xil ../src_post_encryption ../reports/* ../checkpoints/*
