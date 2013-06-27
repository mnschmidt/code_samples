require 'net/ldap'

class User < ActiveRecord::Base
  has_many :studies
  has_many :freesurfer_qualities
  
  def to_label
    "#{first_name} - #{microsession}"
  end
  
  def self.authenticate(login, password)
    login = login.to_s
    userid = login
    
    #dn = nil

    ldap = Net::LDAP.new(:host => "10.30.4.1", :base => "dc=van-gogh,dc=erasmusmc,dc=nl")
    filter = Net::LDAP::Filter.eq('uid', login)
    ldap.search(:filter => filter) {|entry| login = entry.dn}
    #if dn == nil
    #  return nil
    #end
    ldap.auth(login, password)

    if ldap.bind
      # possibly deprecated
      #find(:first, :conditions => {:login => userid})
      find_by_login(userid)
    else
      return nil
    end
  end
  
  def after_destroy
    unless User.exists?(:admin => true)
      raise "Can't delete the last administrator."
    end
  end
  
  def is_admin?
    self.admin
  end
end
