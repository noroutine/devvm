Facter.add(:user_facts, :type => :aggregate) do

  user_config_raw = `git config --file /vagrant/user.config --list 2> /dev/null`

  truth = {
    "true" => true,
    "yes" => true,
    "1" => true,
    "false" => false,
    "no" => false,
    "0" => false,
  }

  # Defaults
  result = {
    "debug" => {
      "noapps" => false,
    },
    "vm" => {
      "autologin" => true,
      "autologinusername" => "tomcat",
      "windowmanager" => "gnome",
    },
    "ldap" => {
      "username" => "tomcat",
    },
    "user" => {
      "name" => "Anonymous Coward",
      "email" => "tomcat@hq-vm-dev-svr",
    }
  }

  user_config_raw.split("\n").each do |line|
    key, value = line.split('=')
    section, option = key.split('.')

    result[section] = {} if not result[section]

    if truth.has_key?(value.to_s)
      result[section][option] = truth[value.to_s]
    elsif
      result[section][option] = value
    end
  end

  aggregate do |chunks|
    result
  end

end