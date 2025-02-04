require "test_helper"

describe Work do
  describe 'validations' do
    before do
      # Arrange
      @work = Work.new(category: "book", title: "A River Runs Through It", creator: "Norman Maclean", publication_year: 1991, description: "Fly fishing in Montana")
    end
    
    it 'is valid when all fields are present' do
      expect(@work.valid?).must_equal true
    end
    
    it 'is valid if the title is not unique but is a different category' do
      @work.title = works(:blue).title
      
      expect(@work.valid?).must_equal true
    end
    
    it 'is invalid without a title' do
      @work.title = nil
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title
    end
    
    it 'is invalid if the title is not unique within the same category' do
      @work.title = works(:green).title
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title
    end
  end
  
  describe 'relations' do
    it 'a work can have many votes' do
      work = works(:green)
      expect(work.votes.count).must_equal 2
    end
  end
  
  describe 'custom methods' do
    
    it 'properly sorts works by specified category' do
      all_works = Work.all
      book_list = all_works.media_sort('book')
      
      expect(book_list[0].category).must_equal 'book'
      expect(book_list[-1].category).must_equal 'book'
      expect(book_list.count).must_equal 10
      
      movie_list = all_works.media_sort('movie')
      expect(movie_list.count).must_equal 0
      expect(movie_list.first).must_equal nil
    end
    
    it 'properly identifies the top voted work' do
      top_voted = Work.top_voted # when there are votes
      
      expect(top_voted).must_equal works(:winter)
      
    end
    
    it 'identifies the top ten voted works by category and orders by vote count' do
      top_albums = Work.top_ten('album') #There are 11 voted albums
      
      expect(top_albums.count).must_equal 10
      expect(top_albums.first).must_equal works(:winter)
      expect(top_albums.last).must_equal works(:goodbye)
      
      top_books = Work.top_ten('book') #There are 0 voted books
      expect(top_books.count).must_equal 10
    end
  end
end
