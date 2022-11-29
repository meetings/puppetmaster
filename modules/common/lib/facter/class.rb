# Fact: class
#
# Classify clients based on their computing environments.
#
# 2013-05-11 / Meetin.gs

require 'facter'

Facter.add(:class) do
    setcode do
        if not Facter.value("ec2_instance_id").nil?
            "aws"
        elsif Facter.value("virtual").eql?("xen0") or File.exist?("/etc/dom0")
            "dom0"
        elsif File.exist?("/etc/domU")
            "domU"
        else
            "unknown"
        end
    end
end
