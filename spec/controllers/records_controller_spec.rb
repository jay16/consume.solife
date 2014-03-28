require 'spec_helper'

describe RecordsController do

  # This should return the minimal set of attributes required to create a valid
  # Record. As you add validations to Record, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "user_id" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all records as @records" do
      record = Record.create! valid_attributes
      get :index, {}, valid_session
      assigns(:records).should eq([record])
    end
  end

  describe "GET show" do
    it "assigns the requested record as @record" do
      record = Record.create! valid_attributes
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
      record = Record.create! valid_attributes
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
        Record.any_instance.stub(:save).and_return(false)
        post :create, {:record => { "user_id" => "invalid value" }}, valid_session
        assigns(:record).should be_a_new(Record)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Record.any_instance.stub(:save).and_return(false)
        post :create, {:record => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested record" do
        record = Record.create! valid_attributes
        # Assuming there are no other records in the database, this
        # specifies that the Record created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Record.any_instance.should_receive(:update).with({ "user_id" => "1" })
        put :update, {:id => record.to_param, :record => { "user_id" => "1" }}, valid_session
      end

      it "assigns the requested record as @record" do
        record = Record.create! valid_attributes
        put :update, {:id => record.to_param, :record => valid_attributes}, valid_session
        assigns(:record).should eq(record)
      end

      it "redirects to the record" do
        record = Record.create! valid_attributes
        put :update, {:id => record.to_param, :record => valid_attributes}, valid_session
        response.should redirect_to(record)
      end
    end

    describe "with invalid params" do
      it "assigns the record as @record" do
        record = Record.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Record.any_instance.stub(:save).and_return(false)
        put :update, {:id => record.to_param, :record => { "user_id" => "invalid value" }}, valid_session
        assigns(:record).should eq(record)
      end

      it "re-renders the 'edit' template" do
        record = Record.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Record.any_instance.stub(:save).and_return(false)
        put :update, {:id => record.to_param, :record => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested record" do
      record = Record.create! valid_attributes
      expect {
        delete :destroy, {:id => record.to_param}, valid_session
      }.to change(Record, :count).by(-1)
    end

    it "redirects to the records list" do
      record = Record.create! valid_attributes
      delete :destroy, {:id => record.to_param}, valid_session
      response.should redirect_to(records_url)
    end
  end

end
