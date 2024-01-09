let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICocvZWgQkh9S4y4xRO0VgOxIeNjprTY+k8FwdY7g5tQ";

  summit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTpT9yTALkZI0pM4Fq03wvGAKVqf7xmPwnMoB9fsoNx";
  sierra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTpT9yTALkZI0pM4Fq03wvGAKVqf7xmPwnMoB9fsoNx";
  systems = [
    summit
    sierra
  ];
in
{
  "summit/secrets/password.age".publicKeys = [
    user
    summit
  ];
  "sierra/secrets/password.age".publicKeys = [
    user
    sierra
  ];
}
