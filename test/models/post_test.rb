require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = @user.posts.build(content: "New Post") 
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end
  
   test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "content should be at most 250 characters" do
    @post.content = "a" * 251
    assert_not @post.valid?
  end
  
  test "order should be most recent first" do
    assert_equal posts(:two), Post.first
  end
end
