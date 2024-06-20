FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y   build-essential   git   python3   qemu-utils   wget   sudo

# Create a non-root user
RUN useradd -ms /bin/bash vscode
RUN echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Clone TinyEMU and BookwormPup ISO
COPY tinyemu /tinyemu
WORKDIR /tinyemu

RUN wget -O /tinyemu/BookwormPup64_10.0.6.iso https://archive.org/download/Puppy_Linux_Bookworm_Pup/bookwormPup64-10.0.6.iso   && qemu-img create -f qcow2 /tinyemu/puppy-bookworm.qcow2 2G   && qemu-system-x86_64 -cdrom /tinyemu/BookwormPup64_10.0.6.iso -boot d -hda /tinyemu/puppy-bookworm.qcow2

# Expose port for HTTP server
EXPOSE 8000

# Command to run HTTP server
CMD ["python3", "-m", "http.server", "8000"]
