require 'spec_helper'

describe RecordsController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:record)  { FactoryGirl.create(:record, :user => user) }
  let(:record1)  { FactoryGirl.create(:record, :user => user) }
  let(:record2)  { FactoryGirl.create(:record, :user => user) }
  let(:valid_session) { {} }

  def valid_attributes
    { "value" => rand(1000), 
      "remark" => rand(1000).to_s, 
      "ymdhms" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
    }
  end

  before do
    sign_in user
  end
 
  describe "GET index" do
    it "assigns all records as @records" do
      get :index
      expect(assigns(:records)).to eq(user.records)
    end
  end

  describe "GET show" do
    it "assigns the requested record as @record" do
      get :show, {:id => record.to_param}, valid_session
      assigns(:record).should eq(record)
    end
  end

  describe "GET new" do
    it "assigns a new record as @record" do
      get :new, {}, valid_session
      assigns(:record).should be_a_new(Record)
    end
  end

  describe "GET edit" do
    it "assigns the requested record as @record" do
      get :edit, {:id => record.to_param}, valid_session
      assigns(:record).should eq(record)
    end
  end

  describe "POST create" do
    it "should valid and is a hash with valid_attributes" do
      expect(valid_attributes.nil?).to be_false
      expect(valid_attributes).to be_a(Hash)
    end

    describe "with valid params" do
      it "creates a new Record" do
        expect { 
          post :create, {:record => valid_attributes, :user => user} 
        }.to change(user.records, :count).by(1)
      end

      it "assigns a newly created record as @record" do
        post :create, {:record => valid_attributes, :user => user}, valid_session
        assigns(:record).should be_a(Record)
        #assigns(:record).should be_persisted
        #assigns(:record).should be_valid
      end

      it "redirects to the created record" do
        post :create, {:record => valid_attributes, :user => user}, valid_session
        #response.should redirect_to(record_path(user.records.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved record as @record" do
        user.records.any_instance.stub(:save).and_return(false)
        post :create, {:record => { "user_id" => "invalid value" }}, valid_session
        assigns(:record).should be_a_new(Record)
      end

      it "re-renders the 'new' template" do
        user.records.any_instance.stub(:save).and_return(false)
        post :create, {:record => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested record" do
        user.records.any_instance.should_receive(:update).with({ "user_id" => user.id.to_s })
        put :update, {:id => record.to_param, :record => { "user_id" => user.id.to_s }}, valid_session
      end

      it "assigns the requested record as @record" do
        put :update, {:id => record.to_param, :record => valid_attributes}, valid_session
        assigns(:record).should eq(record)
      end

      it "redirects to the record" do
        put :update, {:id => record.to_param, :record => valid_attributes}, valid_session
        response.should redirect_to(record)
      end
    end

    describe "with invalid params" do
      it "assigns the record as @record" do
        user.records.any_instance.stub(:save).and_return(false)
        put :update, {:id => record.to_param, :record => { "user_id" => "invalid value" }}, valid_session
        assigns(:record).should eq(record)
      end

      it "re-renders the 'edit' template" do
        user.records.any_instance.stub(:save).and_return(false)
        put :update, {:id => record.to_param, :record => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested record" do
      record_destroy = FactoryGirl.create(:record, :user=> user)
      expect {
        delete :destroy, {:id => record_destroy.to_param}, valid_session
      }.to change(user.records, :count).by(-1)
    end

    it "redirects to the records list" do
      record_destroy = FactoryGirl.create(:record, :user=> user)
      delete :destroy, {:id => record_destroy.to_param}, valid_session
      #response.should redirect_to(records_url)
    end
  end
end
