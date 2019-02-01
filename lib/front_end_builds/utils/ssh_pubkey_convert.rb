# This is needed to convert an SSH pubkey into a RSA OpenSSL pubkey that we can
# use to verify the signature. I got this from:
#
# https://github.com/mytestbed/omf/blob/master/omf_common/lib/omf_common/auth/ssh_pub_key_convert.rb
#

module FrontEndBuilds
  module Utils
    # Copyright (c) 2012 National ICT Australia Limited (NICTA).
    # This software may be used and distributed solely under the terms of the MIT license (License).
    # You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
    # By downloading or using this software you accept the terms and the liability disclaimer in the License.

    require 'base64'
    require 'openssl'

    # This file provides a converter that accepts an SSH public key string
    # and converts it to an OpenSSL::PKey::RSA object for use in verifying
    # received messages.  (DSA support pending).
    #
    class SSHPubKeyConvert
      # Unpack a 4-byte unsigned integer from the +bytes+ array.
      #
      # Returns a pair (+u32+, +bytes+), where +u32+ is the extracted
      # unsigned integer, and +bytes+ is the remainder of the original
      # +bytes+ array that follows +u32+.
      #
      def self.unpack_u32(bytes)
        return bytes.unpack("N")[0], bytes[4..-1]
      end

      # Unpack a string from the +bytes+ array.  Exactly +len+ bytes will
      # be extracted.
      #
      # Returns a pair (+string+, +bytes+), where +string+ is the
      # extracted string (of length +len+), and +bytes+ is the remainder
      # of the original +bytes+ array that follows +string+.
      #
      def self.unpack_string(bytes, len)
        return bytes.unpack("A#{len}")[0], bytes[len..-1]
      end

      # Convert a string in SSH public key format to a key object
      # suitable for use with OpenSSL.  If the key is an RSA key then an
      # OpenSSL::PKey::RSA object is returned.  If the key is a DSA key
      # then an OpenSSL::PKey::DSA object is returned.  In either case,
      # the object returned is suitable for encrypting data or verifying
      # signatures, but cannot be used for decrypting or signing.
      #
      # The +keystring+ should be a single line, as per an SSH public key
      # file as generated by +ssh-keygen+, or a line from an SSH
      # +authorized_keys+ file.
      #
      def self.convert(keystring)
        (_, b64, _) = keystring.split(' ')
        raise ArgumentError, "Invalid SSH public key '#{keystring}'" if b64.nil?

        decoded_key = Base64.decode64(b64)
        (n, bytes) = unpack_u32(decoded_key)
        (keytype, bytes) = unpack_string(bytes, n)

        if keytype == "ssh-rsa"
          (n, bytes) = unpack_u32(bytes)
          (estr, bytes) = unpack_string(bytes, n)
          (n, bytes) = unpack_u32(bytes)
          (nstr, bytes) = unpack_string(bytes, n)

          key = OpenSSL::PKey::RSA.new

          # support SSL 2
          if Gem::Version.new(OpenSSL::VERSION) < Gem::Version.new('2.0.0')
            key.n = OpenSSL::BN.new(nstr, 2)
            key.e = OpenSSL::BN.new(estr, 2)
          else
            # params are n, e, d
            key.set_key(OpenSSL::BN.new(nstr, 2), OpenSSL::BN.new(estr, 2), nil)
          end

          key
        elsif keytype == 'ssh-dss'
          (n, bytes) = unpack_u32(bytes)
          (pstr, bytes) = unpack_string(bytes, n)
          (n, bytes) = unpack_u32(bytes)
          (qstr, bytes) = unpack_string(bytes, n)
          (n, bytes) = unpack_u32(bytes)
          (gstr, bytes) = unpack_string(bytes, n)
          (n, bytes) = unpack_u32(bytes)
          (pkstr, bytes) = unpack_string(bytes, n)

          key = OpenSSL::PKey::DSA.new

          # support SSL 2
          if Gem::Version.new(OpenSSL::VERSION) < Gem::Version.new('2.0.0')
            # TODO make this work for DSA w/ open SSL 2
            key.p = OpenSSL::BN.new(pstr, 2)
            key.q = OpenSSL::BN.new(qstr, 2)
            key.g = OpenSSL::BN.new(gstr, 2)
            key.pub_key = OpenSSL::BN.new(pkstr, 2)
          else
            # params are set_pqg(p, q, g) → self
            key.set_pqg(
              OpenSSL::BN.new(pstr, 2),
              OpenSSL::BN.new(qstr, 2),
              OpenSSL::BN.new(gstr, 2)
            )
            key.set_key(OpenSSL::BN.new(pkstr, 2), nil)
          end

          key
        else
          # waiting for the sshkey gem to support other key types
          raise "Unsupported key type: #{keytype}"
        end
      end
    end
  end
end
