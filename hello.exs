defmodule LatticeBasedCryptography do
  use Ecto.Schema

  schema "lattice_based_cryptography" do
    field :message, String
    field :public_key, binary
    field :private_key, binary
  end

  def create(message) do
    public_key, private_key = generate_keys()
    %LatticeBasedCryptography{message: message, public_key: public_key, private_key: private_key}
  end

  def encrypt(lattice_based_cryptography) do
    ciphertext = encrypt_message(lattice_based_cryptography.message, lattice_based_cryptography.public_key)
    %LatticeBasedCryptography{message: lattice_based_cryptography.message, ciphertext: ciphertext}
  end

  def decrypt(lattice_based_cryptography) do
    plaintext = decrypt_message(lattice_based_cryptography.ciphertext, lattice_based_cryptography.private_key)
    %LatticeBasedCryptography{message: plaintext, ciphertext: lattice_based_cryptography.ciphertext}
  end

  defp generate_keys() do
    key_pair = NTRU.generate_key_pair(4096)
    %Tuple{public_key: key_pair.public_key, private_key: key_pair.private_key}
  end

  defp encrypt_message(message, public_key) do
    ciphertext = NTRU.encrypt(message, public_key)
    ciphertext
  end

  defp decrypt_message(ciphertext, private_key) do
    plaintext = NTRU.decrypt(ciphertext, private_key)
    plaintext
  end
end

# สร้างวัตถุ LatticeBasedCryptography
lattice_based_cryptography = LatticeBasedCryptography.create("สวัสดีชาวโลก")

# เข้ารหัสข้อความ
ciphertext = LatticeBasedCryptography.encrypt(lattice_based_cryptography)

# ถอดรหัสข้อความ
plaintext = LatticeBasedCryptography.decrypt(lattice_based_cryptography)

# ตรวจสอบข้อความที่ถอดรหัส
IO.inspect(plaintext)