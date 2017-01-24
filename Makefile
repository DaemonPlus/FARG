
default: check doc

doc:
	pod2man --release="farg" --name="farg" --center=" " farg.1.pod > farg.1

check:
	shellcheck farg.sh
	podchecker farg.1.pod
