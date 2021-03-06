# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task1)
    @token = login('User1', 'OhNoItsPassword')
  end

  test 'should get index' do
    get tasks_url,
        headers: {
          "Authorization": @token
        },
        as: :json
    assert_response :success
  end

  test 'should create task' do
    assert_difference('Task.count') do
      post tasks_url,
           headers: {
             "Authorization": @token
           },
           params:
             { task: { is_done: @task.is_done, name: @task.name } },
           as: :json
    end

    assert_response 201
  end

  test 'should show task' do
    get task_url(@task),
        headers: {
          "Authorization": @token
        },
        as: :json
    assert_response :success
  end

  test 'should update task' do
    patch task_url(@task),
          headers: {
            "Authorization": @token
          },
          params: { task: { is_done: @task.is_done, name: @task.name } }, as: :json
    assert_response 200
  end

  test 'should destroy task' do
    assert_difference('Task.count', -1) do
      delete task_url(@task),
             headers: {
               "Authorization": @token
             },
             as: :json
    end

    assert_response 204
  end
end
