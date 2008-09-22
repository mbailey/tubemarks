require File.dirname(__FILE__) + '/../test_helper'

class ViewsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:views)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_view
    assert_difference('View.count') do
      post :create, :view => { }
    end

    assert_redirected_to view_path(assigns(:view))
  end

  def test_should_show_view
    get :show, :id => views(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => views(:one).id
    assert_response :success
  end

  def test_should_update_view
    put :update, :id => views(:one).id, :view => { }
    assert_response :success
#    assert_redirected_to view_path(assigns(:view))
  end

  def test_should_destroy_view
    assert_difference('View.count', -1) do
      delete :destroy, :id => views(:one).id
    end

    assert_redirected_to views_path
  end
end
