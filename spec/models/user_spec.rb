require 'spec_helper'

describe User do
  
  before do
    @user = create(:user)
  end

  subject { @user }
 
  it { should have_many(:records) }
  it { should have_many(:tags) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password) }
end
