import React from 'react';
import { mount } from '@cypress/react';

import FoilCardImage from 'components/FoilCardImage';
import DisplayContext from 'contexts/DisplayContext';

describe('FoilCardImage', () => {
  it('can mount', () => {
    mount(
      <DisplayContext.Provider value={{ showCustomImages: false }}>
        <FoilCardImage
          card={{
            details: {
              image_normal:
                'https://c1.scryfall.com/file/scryfall-cards/large/front/9/5/958c27db-68fa-47e9-a9c3-82f0c92e86c1.jpg?1562926614',
            },
          }}
        />
      </DisplayContext.Provider>,
    );
  });
});
