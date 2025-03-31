import monitorScroll from 'srraf';

export default class Header {
  static defaults = {
    scrollClass: 'has-scrolled',
    transformOnScroll: true,
    transformPosition: 0,
    transformClass: 'transform-on-scroll',
  };

  constructor(element, config = {}) {
    this.element = element;
    this.config = { ...Header.defaults, ...config };
    this.scrollingDown = null;
    this.scrollingUp = null;
    this.fixedTopYPos = null;
    this.init();
  }

  init() {
    this.createChildRefs().layout().enable();
    return this;
  }

  createChildRefs() {
    return this;
  }

  layout() {
    if (this.config.transformOnScroll) {
      this.element.classList.add(this.config.transformClass);
    }

    return this;
  }

  enable() {
    if (this.config.transformOnScroll) {
      this.transformHeader();
    }
  }

  onScrollDown = () => {
    this.fixedTopYPos = null;
    if(window.innerWidth <= 767)
    {
      return;
    }
    if (!this.scrollingDown) {
      this.element.classList.add(this.config.scrollClass);
      const headerHeight = 100;
      const distanceFromTop = Math.abs(
        document.body.getBoundingClientRect().top
      );
      if (distanceFromTop >= headerHeight && document.querySelector('html').offsetHeight - this.element.offsetHeight > window.innerHeight)
      {
        this.element.classList.add('fixed-top');
        this.fixedTopYPos = Math.abs(document.body.getBoundingClientRect().top);
      }
      else
      {
        this.element.classList.remove('fixed-top');
      }
      this.scrollingDown = true;
      this.scrollingUp = false;
    }
  };

  onScrollUp = () => { 
    if(this.fixedTopYPos != null && this.fixedTopYPos === Math.abs(document.body.getBoundingClientRect().top))
    {
      this.fixedTopYPos = null;
      return;
    }
    this.fixedTopYPos = null;
    if(window.innerWidth <= 767)
    {
      return;
    }
    const headerHeight = 100;
    const distanceFromTop = Math.abs(
      document.body.getBoundingClientRect().top
    );
    if (distanceFromTop >= headerHeight && document.querySelector('html').offsetHeight - this.element.offsetHeight > window.innerHeight) 
    {
      this.element.classList.add('fixed-top');
    }
    else 
    {
      this.element.classList.remove('fixed-top');
    }
    if (!this.scrollingUp) {
      this.element.classList.remove(this.config.scrollClass);
      this.scrollingUp = true;
      this.scrollingDown = false;
    }
  };

  transformHeader = () => {
    monitorScroll(({ y, py }) => {
      if (y <= this.config.transformPosition || y < py) {
        this.onScrollUp();
      } else {
        this.onScrollDown();
      }
    });
  };
}
