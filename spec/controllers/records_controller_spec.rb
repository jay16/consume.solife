require 'spec_helper'

describe RecordsController do
  let(:user) { double(:user) }
  let(:valid_attributes) { {value: rand(1000),remark: "mark#{rand(100)}", ymdhms: Time.now.strftime("%Y-%m-%d %H:%M:%S")} }
  let(:record)  { user.records.create!(valid_attributes) }
  let(:record1) { user.records.create!(valid_attributes) }
  let(:record2) { user.records.create!(valid_attributes) }
  let(:records) { [record,record1,record2] }
  let(:valid_session) {}
 
  describe "GET index" do
    it "assigns all records as @records" do
      get :index
      expect(assigns(:records)).to eq(records)
    end
  end
=begin
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
    describe "with valid params" do
      it "creates a new Record" do
        expect {
          post :create, {:record => valid_attributes}, valid_session
        }.to change(Record, :count).by(1)
      end

      it "assigns a newly created record as @record" do
        post :create, {:record => valid_attributes}, valid_session
        assigns(:record).should be_a(Record)
        assigns(:record).should be_persisted
      end

      it "redirects to the created record" do
        post :create, {:record => valid_attributes}, valid_session
        response.should redirect_to(Record.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved record as @record" do
        # Trigger the behavior that occurs when invalid params are submitted
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
        user.records.any_instance.should_receive(:update).with({ "user_id" => "1" })
        put :update, {:id => record.to_param, :record => { "user_id" => "1" }}, valid_session
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
      expect {
        delete :destroy, {:id => record.to_param}, valid_session
      }.to change(Record, :count).by(-1)
    end

    it "redirects to the records list" do
      delete :destroy, {:id => record.to_param}, valid_session
      response.should redirect_to(records_url)
    end
  end
=end
end
